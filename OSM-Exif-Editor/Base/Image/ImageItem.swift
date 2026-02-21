/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation
import CloudKit
import Photos

class ImageItem: MapItem{
    
    var metaData: ImageMetaData? = nil
    
    var url: URL
    var previewData: Data? = nil
    
    var imageData: Data?{
        if let data = FileManager.default.readFile(url: url){
            return data
        }
        Log.error("image file does not exist: \(url)")
        return nil
    }
    
    var image: OSImage?{
        if let data = imageData{
            return OSImage(data: data)
        }
        return nil
    }
    
    var preview: OSImage?{
        if let data = previewData{
            return OSImage(data: data)
        }
        return nil
    }
    
    init(url: URL){
        self.url = url
        super.init()
    }
    
    @discardableResult
    func loadMetaData() -> Bool{
        if let data = FileManager.default.readFile(url: url){
            loadMetaData(from: data)
            return true
        }
        return false
    }
    
    func loadMetaData(from data: Data){
        metaData = ImageMetaData()
        metaData!.readData(data: data)
    }
    
    @discardableResult
    func saveImageAndCreatePreview(data: Data) -> Bool{
        if saveImage(data: data), let original = OSImage(data: data), createPreviewFile(original: original){
            Log.debug("save image and preview")
            return true
        }
        Log.error("did not save image and preview")
        return false
    }
    
    @discardableResult
    func copyImageAndCreatePreview(from: URL, original: OSImage) -> Bool{
        if copyImage(from: from), createPreviewFile(original: original){
            Log.debug("save image and preview")
            return true
        }
        Log.error("did not save image and preview")
        return false
    }
    
    @discardableResult
    func createPreview() -> Bool{
        if let image = image, createPreviewFile(original: image){
            Log.debug("save image and preview")
            return true
        }
        Log.error("did not save image and preview")
        return false
    }
    
    @discardableResult
    func saveImage(data: Data) -> Bool{
        return FileManager.default.saveFile(data: data, url: url)
    }
    
    @discardableResult
    func copyImage(from: URL) -> Bool{
        return FileManager.default.copyFile(fromURL: from, toURL: url, replace: true)
    }
    
    @discardableResult
    func createPreviewFile(original: OSImage) -> Bool{
        if let preview = OSImage.createResizedImage(of: original, size: 200){
            if let previewData = OSImage.getJpegData(from: preview){
                self .previewData = previewData
                return true
            }
        }
        return false
    }
    
    func updateData(_ oldData: Data) -> Data?{
        let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
        if let imageSource = CGImageSourceCreateWithData(oldData as CFData, options as CFDictionary) {
            let uti: CFString = CGImageSourceGetType(imageSource)!
            let newData: NSMutableData = NSMutableData(data: oldData)
            let destination: CGImageDestination = CGImageDestinationCreateWithData((newData as CFMutableData), uti, 1, nil)!
            if let oldMetaData: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options as CFDictionary){
                let newMetaData: NSMutableDictionary = oldMetaData.mutableCopy() as! NSMutableDictionary
                metaData?.modifyDictionary(dict: newMetaData)
                CGImageDestinationAddImageFromSource(destination, imageSource, 0, (newMetaData as CFDictionary))
                CGImageDestinationFinalize(destination)
                return newData as Data
            }
        }
        return nil
    }
    
    func updateEditedImage(coordinate: CLLocationCoordinate2D?, creationDate: Date?){
        if let data = FileManager.default.readFile(url: url){
            loadMetaData(from: data)
            if let coordinate = coordinate{
                self.coordinate = coordinate
                metaData!.latitude = coordinate.latitude
                metaData!.longitude = coordinate.longitude
            }
            if let creationDate = creationDate, creationDate != metaData!.dateTime{
                self.creationDate = creationDate
                metaData!.dateTime = creationDate
            }
            if let data = updateData(data){
                if FileManager.default.fileExists(url: url){
                    FileManager.default.deleteFile(url: url)
                }
                setModified()
                FileManager.default.saveFile(data: data, url: url)
            }
        }
    }
    
}

typealias ImageItemList = LocationList<ImageItem>

extension ImageItemList{
    
    mutating func sortByDate(ascending: Bool){
        if ascending{
            self.sort(by: { $0.creationDate < $1.creationDate})
        }
        else{
            self.sort(by: { $0.creationDate > $1.creationDate})
        }
    }
    
}

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
    
    var exifData: ImageExifData? = nil
    
    var hasExifData: Bool{
        exifData != nil
    }
    
    var exifCreationDateString: String{
        exifData?.exifCreationDate?.dateTimeString() ?? ""
    }
    
    var hasGPSData: Bool{
        exifData?.hasGPSData ?? false
    }
    
    var hasValidGPSData: Bool{
        exifData?.hasValidGPSData ?? false
    }
    
    var url: URL
    var fileName: String
    var size = -1
    var isHidden = false
    var fileCreationDate: Date? = nil
    var fileModificationDate: Date? = nil
    var previewData: Data? = nil
    
    var path: String{
        url.path
    }
    
    var pathExtension: String{
        url.pathExtension.lowercased()
    }
    
    var parentURL: URL?{
        url.parentURL
    }
    
    var sizeString: String{
        if size == -1{
            return ""
        }
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
    
    var creationDateString: String{
        fileCreationDate?.dateTimeString() ?? ""
    }
    
    var modificationDateString: String{
        fileModificationDate?.dateTimeString() ?? ""
    }
    
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
        self.fileName = url.lastPathComponent
        super.init()
    }
    
    @discardableResult
    func assertExifData() -> Bool{
        if self.exifData == nil{
            if AppData.shared.startSecurityScope() ,let exifData = ImageExifData.getExifData(from: url){
                self.exifData = exifData
                AppData.shared.stopSecurityScope()
            }
        }
        return exifData != nil
    }
    
    @discardableResult
    func createPreview() -> Bool{
        if let image = image, createPreviewFile(original: image){
            Log.debug("created preview")
            return true
        }
        Log.error("did not create preview")
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
    
    func setCreationDateToExifDate() -> Bool{
        if let creationDate = exifData?.exifCreationDate, AppData.shared.startSecurityScope(){
            fileCreationDate = creationDate
            url.creation = fileCreationDate
            AppData.shared.stopSecurityScope()
            return true
        }
        return false
    }
    
    func setExifDateToCreationDate() -> Bool{
        if let date = fileCreationDate{
            return setExifCreationDate(date)
        }
        return false
    }
    
    func setExifCreationDate(_ date: Date) -> Bool{
        if assertExifData(), let exifData = exifData{
            exifData.exifCreationDate = date
            return saveModifiedExifData()
        }
        return false
    }
    
    func setGPSCoordinates(latitude: Double, longitude: Double, altitude: Double) -> Bool{
        if assertExifData(), let exifData = exifData{
            exifData.exifLatitude = latitude
            exifData.exifLongitude = longitude
            exifData.exifAltitude = altitude
            return saveModifiedExifData()
        }
        return false
    }
    
    func saveModifiedExifData() -> Bool{
        var success = false
        if AppData.shared.startSecurityScope(), let exifData = exifData, let oldData = FileManager.default.readFile(url: url){
            let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
            if let imageSource = CGImageSourceCreateWithData(oldData as CFData, options as CFDictionary) {
                let uti: CFString = CGImageSourceGetType(imageSource)!
                let newData: NSMutableData = NSMutableData(data: oldData)
                let destination: CGImageDestination = CGImageDestinationCreateWithData((newData as CFMutableData), uti, 1, nil)!
                if let oldMetaData: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options as CFDictionary){
                    let newMetaData: NSMutableDictionary = oldMetaData.mutableCopy() as! NSMutableDictionary
                    exifData.modifyExif(dict: newMetaData)
                    CGImageDestinationAddImageFromSource(destination, imageSource, 0, (newMetaData as CFDictionary))
                    CGImageDestinationFinalize(destination)
                    success = FileManager.default.saveFile(data: newData as Data, url: url)
                    url.creation = fileCreationDate
                }
            }
            AppData.shared.stopSecurityScope()
        }
        return success
    }
    
}

typealias ImageItemList = MappointList<ImageItem>

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

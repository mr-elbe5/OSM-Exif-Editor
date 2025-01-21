/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import AppKit
import Photos

@Observable class ImageData : Equatable, Hashable{
    
    static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        lhs.id == rhs.id
    }
    
    static var previewSize: CGFloat = 512
    
    var id : UUID = UUID()
    var url : URL
    var width: Double?
    var height: Double?
    var orientation: Int?
    var aperture: String?
    var brightness: String?
    var dateTime: Date?
    var offsetTime: String?
    var cameraModel: String?
    var altitude: Double?
    var latitude: Double?
    var longitude: Double?
    var preview: NSImage? = nil
    
    var coordinate: CLLocationCoordinate2D?{
        if let latitude = latitude, let longitude = longitude{
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
    
    var metaData: NSDictionary {
        return [
            kCGImagePropertyPixelWidth: width as Any,
            kCGImagePropertyPixelHeight: height as Any,
            kCGImagePropertyOrientation: orientation as Any,
            kCGImagePropertyExifDictionary : [
                kCGImagePropertyExifApertureValue: aperture as Any,
                kCGImagePropertyExifBrightnessValue: brightness as Any,
                kCGImagePropertyExifDateTimeOriginal: dateTime as Any,
                kCGImagePropertyExifOffsetTime: offsetTime as Any
            ],
            kCGImagePropertyTIFFDictionary : [
                kCGImagePropertyTIFFModel: cameraModel
            ],
            kCGImagePropertyGPSDictionary : [
                kCGImagePropertyGPSAltitude: altitude as Any,
                kCGImagePropertyGPSLatitude: latitude as Any,
                kCGImagePropertyGPSLongitude: longitude as Any
            ]
        ]
    }
    
    init(url: URL, data: Data){
        id = UUID()
        self.url = url
        readMetaData(data: data)
    }
    
    func readMetaData(data: Data) {
        let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
        if let imgSrc = CGImageSourceCreateWithData(data as CFData, options as CFDictionary) {
            if let metadata: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary){
                readDictionary(dict: metadata)
            }
        }
    }
    
    func readDictionary(dict: NSDictionary) {
        self.width = dict[kCGImagePropertyPixelWidth] as? Double
        self.height = dict[kCGImagePropertyPixelHeight] as? Double
        self.orientation = dict[kCGImagePropertyOrientation] as? Int
        if let tiffData = dict[kCGImagePropertyTIFFDictionary] as? NSDictionary {
            self.cameraModel = tiffData[kCGImagePropertyTIFFModel] as? String
        }
        if let exifData = dict[kCGImagePropertyExifDictionary] as? NSDictionary {
            self.aperture = exifData[kCGImagePropertyExifApertureValue] as? String
            self.brightness = exifData[kCGImagePropertyExifBrightnessValue] as? String
            self.dateTime = DateFormats.exifDateFormatter.date(from: exifData[kCGImagePropertyExifDateTimeOriginal] as? String ?? "")
            self.offsetTime = exifData[kCGImagePropertyExifOffsetTime] as? String
        }
        if let gpsData = dict[kCGImagePropertyGPSDictionary] as? NSDictionary {
            self.altitude = gpsData[kCGImagePropertyGPSAltitude] as? Double
            self.latitude = gpsData[kCGImagePropertyGPSLatitude] as? Double
            self.longitude = gpsData[kCGImagePropertyGPSLongitude] as? Double
        }
    }
    
    func modifyDictionary(dict: NSMutableDictionary) {
        if let width = width{
            dict[kCGImagePropertyPixelWidth] = width
        }
        if let height = height{
            dict[kCGImagePropertyPixelHeight] = height
        }
        if cameraModel != nil{
            var tiffDict: NSMutableDictionary
            if let  currentTiffDict = dict.value(forKey: kCGImagePropertyTIFFDictionary as String) as? NSMutableDictionary{
                tiffDict = currentTiffDict
            }
            else{
                tiffDict = NSMutableDictionary()
                dict[kCGImagePropertyTIFFDictionary] = tiffDict
            }
            tiffDict[kCGImagePropertyTIFFModel] = cameraModel
        }
        if aperture != nil || brightness != nil || dateTime != nil || offsetTime != nil{
            var exifDict: NSMutableDictionary
            if let  currentExifDict = dict.value(forKey: kCGImagePropertyExifDictionary as String) as? NSMutableDictionary{
                exifDict = currentExifDict
            }
            else{
                exifDict = NSMutableDictionary()
                dict[kCGImagePropertyExifDictionary] = exifDict
            }
            if let aperture = aperture{
                exifDict[kCGImagePropertyExifApertureValue] = aperture
            }
            if let brightness = brightness{
                exifDict[kCGImagePropertyExifBrightnessValue] = brightness
            }
            if let dateTime = dateTime{
                exifDict[kCGImagePropertyExifDateTimeOriginal] = DateFormats.exifDateFormatter.string(for: dateTime)
            }
            if let offsetTime = offsetTime{
                exifDict[kCGImagePropertyExifOffsetTime] = offsetTime
            }
        }
        if altitude != nil || latitude != nil || longitude != nil{
            var gpsDict: NSMutableDictionary
            if let  currentGpsDict = dict.value(forKey: kCGImagePropertyGPSDictionary as String) as? NSMutableDictionary{
                gpsDict = currentGpsDict
            }
            else{
                gpsDict = NSMutableDictionary()
                dict[kCGImagePropertyGPSDictionary] = gpsDict
            }
            if let altitude = altitude{
                gpsDict[kCGImagePropertyGPSAltitude] = altitude
            }
            if let latitude = latitude{
                gpsDict[kCGImagePropertyGPSLatitude] = latitude
            }
            if let longitude = longitude{
                gpsDict[kCGImagePropertyGPSLongitude] = longitude
            }
        }
    }
    
    func asssertPreview(){
        if preview == nil{
            //debugPrint("creating preview for \(url.lastPathComponent)")
            if let data = url.getSecureData(){
                if let preview = NSImage.createResizedImage(of: NSImage(data: data), size: ImageData.previewSize){
                    self.preview = preview
                }
                else{
                    self.preview = NSImage(named: "gear.grey")!
                }
            }
            else{
                self.preview = NSImage(named: "gear.grey")!
            }
        }
    }
    
    func getPreview() -> NSImage{
        asssertPreview()
        return preview!
    }
    
    func getData() -> Data?{
        url.getSecureData()
    }
    
    func saveFile() -> Bool{
        var success = false
        let gotAccess = url.startAccessingSecurityScopedResource()
        if gotAccess{
            if let oldData = FileManager.default.readFile(url: url){
                let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
                if let imageSource = CGImageSourceCreateWithData(oldData as CFData, options as CFDictionary) {
                    let uti: CFString = CGImageSourceGetType(imageSource)!
                    let newData: NSMutableData = NSMutableData(data: oldData)
                    let destination: CGImageDestination = CGImageDestinationCreateWithData((newData as CFMutableData), uti, 1, nil)!
                    if let oldMetaData: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options as CFDictionary){
                        let newMetaData: NSMutableDictionary = oldMetaData.mutableCopy() as! NSMutableDictionary
                        modifyDictionary(dict: newMetaData)
                        CGImageDestinationAddImageFromSource(destination, imageSource, 0, (newMetaData as CFDictionary))
                        CGImageDestinationFinalize(destination)
                        success = FileManager.default.saveFile(data: newData as Data, url: url)
                    }
                }
            }
            url.stopAccessingSecurityScopedResource()
        }
        return success
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
}

typealias ImageDataList = Array<ImageData>

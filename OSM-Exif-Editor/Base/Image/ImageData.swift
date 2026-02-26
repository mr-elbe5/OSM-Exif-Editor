/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation
import Photos

class ImageData: Equatable{
    
    static var previewSize: CGFloat = 512
    
    static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        lhs.url == rhs.url
    }
    
    var url: URL
    var fileCreationDate: Date? = nil
    var fileModificationDate: Date? = nil
    var size: Int = -1
    var exifWidth: Double?
    var exifHeight: Double?
    var exifOrientation: Int?
    var exifAperture: String?
    var exifBrightness: String?
    var exifCreationDate: Date?
    var exifOffsetTime: String?
    var exifCameraModel: String?
    var exifAltitude: Double?
    var exifLatitude: Double?
    var exifLongitude: Double?
    
    var worldPoint: CGPoint?{
        if let coordinate = coordinate{
            return CGPoint(coordinate)
        }
        return nil
    }
    
    var exifLoaded: Bool = false
    
    var isModified: Bool = false
    
    var selected: Bool = false
    
    private var previewData: Data?
    var preview: NSImage{
        if let data = previewData{
            return NSImage(data: data)!
        }
        return NSImage(named: "placeholder")!
    }
    
    var coordinate: CLLocationCoordinate2D?{
        get{
            if let latitude = exifLatitude, let longitude = exifLongitude{
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
            return nil
        }
        set{
            if let coordinate = newValue{
                exifLatitude = coordinate.latitude
                exifLongitude = coordinate.longitude
            }
            else{
                exifLatitude = nil
                exifLongitude = nil
            }
        }
    }
    
    var exifDictionary: NSDictionary {
        return [
            kCGImagePropertyPixelWidth: exifWidth as Any,
            kCGImagePropertyPixelHeight: exifHeight as Any,
            kCGImagePropertyOrientation: exifOrientation as Any,
            kCGImagePropertyExifDictionary : [
                kCGImagePropertyExifApertureValue: exifAperture as Any,
                kCGImagePropertyExifBrightnessValue: exifBrightness as Any,
                kCGImagePropertyExifDateTimeOriginal: exifCreationDate as Any,
                kCGImagePropertyExifOffsetTime: exifOffsetTime as Any
            ],
            kCGImagePropertyTIFFDictionary : [
                kCGImagePropertyTIFFModel: exifCameraModel
            ],
            kCGImagePropertyGPSDictionary : [
                kCGImagePropertyGPSAltitude: exifAltitude as Any,
                kCGImagePropertyGPSLatitude: exifLatitude as Any,
                kCGImagePropertyGPSLongitude: exifLongitude as Any
            ]
        ]
    }
    
    var fileName: String{
        url.lastPathComponent
    }
    
    var hasGPSData: Bool{
        exifLatitude != nil && exifLongitude != nil
    }
    
    var fileExists: Bool{
        if !FileManager.default.fileExists(atPath: url.path){
            Log.error("image file does not exist: \(url)")
            return false
        }
        return true
    }
    
    var creationDate: Date?{
        exifCreationDate ?? fileCreationDate
    }
    
    private var imageData: Data?{
        if let data = FileManager.default.readFile(url: url){
            return data
        }
        Log.error("image file does not exist: \(url)")
        return nil
    }
    
    var image: NSImage?{
        if let data = imageData{
            return NSImage(data: data)
        }
        return nil
    }
    
    var isComplete: Bool{
        previewData != nil && exifLoaded
    }
    
    init(url: URL){
        self.url = url
        if let values = try? url.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey]){
            self.fileCreationDate = values.creationDate
            self.fileModificationDate = values.contentModificationDate
        }
    }
    
    func completeData(completed: @escaping ()->()){
        if isComplete{
            completed()
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            print("completing file for exif and preview")
            if AppData.shared.startSecurityScope(){
                let data = FileManager.default.readFile(url: self.url)
                AppData.shared.stopSecurityScope()
                if let data = data{
                    self.readExifData(data: data)
                    if let image = NSImage(data: data){
                        if self.previewData != nil{
                            DispatchQueue.main.async {
                                completed()
                            }
                            return
                        }
                        Log.info("creating preview for \(self.url.lastPathComponent)")
                        self.createPreviewData(original: image)
                        print("preview created")
                        DispatchQueue.main.async {
                            completed()
                        }
                        return
                    }
                }
                
            }
        }
    }
    
    func createPreviewData(original: NSImage){
        previewData = ImageFactory.shared.createResizedJpegData(original: original, maxSide: ImageData.previewSize)
    }
    
    func resetExifData(){
        exifWidth = nil
        exifHeight = nil
        exifOrientation = nil
        exifAperture = nil
        exifBrightness = nil
        exifCreationDate = nil
        exifOffsetTime = nil
        exifCameraModel = nil
        exifAltitude = nil
        exifLatitude = nil
        exifLongitude = nil
    }
    
    func reloadData(){
        resetExifData()
        if AppData.shared.startSecurityScope(){
            do{
                let resourceValues = try url.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey, .fileSizeKey])
                size = resourceValues.fileSize ?? -1
                fileCreationDate = resourceValues.creationDate
                fileModificationDate = resourceValues.contentModificationDate
                if let data = FileManager.default.readFile(url: self.url){
                    readExifData(data: data)
                }
                isModified = false
                AppData.shared.stopSecurityScope()
            }
            catch{
                
            }
        }
    }
    
    @discardableResult
    func saveModifiedFile() -> Bool{
        var success = false
        if AppData.shared.startSecurityScope(){
            if let oldData = FileManager.default.readFile(url: url){
                let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
                if let imageSource = CGImageSourceCreateWithData(oldData as CFData, options as CFDictionary) {
                    let uti: CFString = CGImageSourceGetType(imageSource)!
                    let newData: NSMutableData = NSMutableData(data: oldData)
                    let destination: CGImageDestination = CGImageDestinationCreateWithData((newData as CFMutableData), uti, 1, nil)!
                    if let oldMetaData: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options as CFDictionary){
                        let newMetaData: NSMutableDictionary = oldMetaData.mutableCopy() as! NSMutableDictionary
                        modifyExifDictionary(dict: newMetaData)
                        CGImageDestinationAddImageFromSource(destination, imageSource, 0, (newMetaData as CFDictionary))
                        CGImageDestinationFinalize(destination)
                        success = FileManager.default.saveFile(data: newData as Data, url: url)
                        url.creation = fileCreationDate
                    }
                }
            }
            AppData.shared.stopSecurityScope()
        }
        return success
    }
    
    func readExifData(data: Data) {
        let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
        if let imgSrc = CGImageSourceCreateWithData(data as CFData, options as CFDictionary) {
            if let metadata: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary){
                readExifDictionary(dict: metadata)
            }
        }
        exifLoaded = true
    }
    
    func readExifDictionary(dict: NSDictionary) {
        self.exifWidth = dict[kCGImagePropertyPixelWidth] as? Double
        self.exifHeight = dict[kCGImagePropertyPixelHeight] as? Double
        self.exifOrientation = dict[kCGImagePropertyOrientation] as? Int
        if let tiffData = dict[kCGImagePropertyTIFFDictionary] as? NSDictionary {
            self.exifCameraModel = tiffData[kCGImagePropertyTIFFModel] as? String
        }
        if let exifData = dict[kCGImagePropertyExifDictionary] as? NSDictionary {
            self.exifAperture = exifData[kCGImagePropertyExifApertureValue] as? String
            self.exifBrightness = exifData[kCGImagePropertyExifBrightnessValue] as? String
            self.exifCreationDate = DateFormats.exifDateFormatter.date(from: exifData[kCGImagePropertyExifDateTimeOriginal] as? String ?? "")
            self.exifOffsetTime = exifData[kCGImagePropertyExifOffsetTime] as? String
        }
        if let gpsData = dict[kCGImagePropertyGPSDictionary] as? NSDictionary {
            self.exifAltitude = gpsData[kCGImagePropertyGPSAltitude] as? Double
            self.exifLatitude = gpsData[kCGImagePropertyGPSLatitude] as? Double
            if let latRef = gpsData[kCGImagePropertyGPSLatitudeRef] as? String{
                if latRef == "S", let lat = self.exifLatitude, lat > 0{
                    self.exifLatitude = -lat
                }
            }
            self.exifLongitude = gpsData[kCGImagePropertyGPSLongitude] as? Double
            if let lonRef = gpsData[kCGImagePropertyGPSLongitudeRef] as? String{
                if lonRef == "W", let lon = self.exifLongitude, lon > 0{
                    self.exifLongitude = -lon
                }
            }
        }
    }
    
    func modifyExifDictionary(dict: NSMutableDictionary) {
        if let width = exifWidth{
            dict[kCGImagePropertyPixelWidth] = width
        }
        if let height = exifHeight{
            dict[kCGImagePropertyPixelHeight] = height
        }
        if exifCameraModel != nil{
            var tiffDict: NSMutableDictionary
            if let  currentTiffDict = dict.value(forKey: kCGImagePropertyTIFFDictionary as String) as? NSMutableDictionary{
                tiffDict = currentTiffDict
            }
            else{
                tiffDict = NSMutableDictionary()
                dict[kCGImagePropertyTIFFDictionary] = tiffDict
            }
            tiffDict[kCGImagePropertyTIFFModel] = exifCameraModel
        }
        if exifAperture != nil || exifBrightness != nil || exifCreationDate != nil || exifOffsetTime != nil{
            var exifDict: NSMutableDictionary
            if let  currentExifDict = dict.value(forKey: kCGImagePropertyExifDictionary as String) as? NSMutableDictionary{
                exifDict = currentExifDict
            }
            else{
                exifDict = NSMutableDictionary()
                dict[kCGImagePropertyExifDictionary] = exifDict
            }
            if let aperture = exifAperture{
                exifDict[kCGImagePropertyExifApertureValue] = aperture
            }
            if let brightness = exifBrightness{
                exifDict[kCGImagePropertyExifBrightnessValue] = brightness
            }
            if let dateTime = exifCreationDate{
                exifDict[kCGImagePropertyExifDateTimeOriginal] = DateFormats.exifDateFormatter.string(for: dateTime)
            }
            if let offsetTime = exifOffsetTime{
                exifDict[kCGImagePropertyExifOffsetTime] = offsetTime
            }
        }
        if exifAltitude != nil || exifLatitude != nil || exifLongitude != nil{
            var gpsDict: NSMutableDictionary
            if let  currentGpsDict = dict.value(forKey: kCGImagePropertyGPSDictionary as String) as? NSMutableDictionary{
                gpsDict = currentGpsDict
            }
            else{
                gpsDict = NSMutableDictionary()
                dict[kCGImagePropertyGPSDictionary] = gpsDict
            }
            if let altitude = exifAltitude{
                gpsDict[kCGImagePropertyGPSAltitude] = altitude
            }
            if let latitude = exifLatitude{
                gpsDict[kCGImagePropertyGPSLatitude] = abs(latitude)
                gpsDict[kCGImagePropertyGPSLatitudeRef] = latitude.sign == .minus ? "S" : "N"
            }
            if let longitude = exifLongitude{
                gpsDict[kCGImagePropertyGPSLongitude] = abs(longitude)
                gpsDict[kCGImagePropertyGPSLongitudeRef] = longitude.sign == .minus ? "W" : "E"
            }
        }
    }
    
}


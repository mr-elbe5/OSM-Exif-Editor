/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation
import Photos

class ImageItem: MapItem{
    
    static var previewSize: CGFloat = 512
    
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
    var exifLoaded: Bool = false
    
    var isModified: Bool = false
    
    private var previewData: Data?
    var preview: NSImage{
        if let data = previewData{
            return NSImage(data: data)!
        }
        return NSImage(named: "placeholder")!
    }
    
    override var coordinate: CLLocationCoordinate2D{
        get{
            CLLocationCoordinate2D(latitude: exifLatitude ?? 0, longitude: exifLongitude ?? 0)
        }
        set{
            exifLatitude = newValue.latitude
            exifLongitude = newValue.longitude
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
    
    var creationDate: Date{
        exifCreationDate ?? fileCreationDate ?? Date()
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
    
    var isReadyForViewing: Bool{
        previewData != nil && exifLoaded
    }
    
    init(url: URL){
        self.url = url
        if let values = try? url.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey]){
            self.fileCreationDate = values.creationDate
            self.fileModificationDate = values.contentModificationDate
        }
        super.init()
    }
    
    func completeData(completed: @escaping ()->()){
        if isReadyForViewing{
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
        if let preview = NSImage.createResizedImage(of: original, size: ImageItem.previewSize){
            previewData = NSImage.getJpegData(from: preview)
        }
    }
    
    @discardableResult
    func deleteFile() -> Bool{
        var success = true
        if FileManager.default.fileExists(url: url){
            if !FileManager.default.deleteFile(url: url){
                Log.error("ImageItem could not delete file: \(fileName)")
                success = false
            }
        }
        return success
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
                        if let creationDate = exifCreationDate{
                            fileCreationDate = creationDate
                            url.creation = fileCreationDate
                        }
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

typealias ImageItemList = MappointList<ImageItem>

extension ImageItemList{
    
    mutating func sort(by sortType: ImageSortType, ascending: Bool){
        switch sortType{
        case .byName:
            self.sort(by: { $0.url.lastPathComponent < $1.url.lastPathComponent})
        case .byExtension:
            self.sort(by: { $0.url.pathExtension.lowercased() < $1.url.pathExtension.lowercased()})
        case .byExifCreation:
            self.sort(by: {
                if let dateLeft = $0.exifCreationDate{
                    if let dateRight = $1.exifCreationDate{
                        return dateLeft < dateRight
                    }
                    return false
                }
                return true
            })
        case .byFileCreation:
            self.sort(by: {
                if let dateLeft = $0.fileCreationDate{
                    if let dateRight = $1.fileCreationDate{
                        return dateLeft < dateRight
                    }
                    return false
                }
                return true
            })
            
        case .byFileModification:
            self.sort(by: {
                if let dateLeft = $0.fileModificationDate{
                    if let dateRight = $1.fileModificationDate{
                        return dateLeft < dateRight
                    }
                    return false
                }
                return true
            })
        case .byLatitude:
            self.sort(by: {
                if let latitudeLeft = $0.exifLatitude{
                    if let latitudeRight = $1.exifLatitude{
                        return latitudeLeft < latitudeRight
                    }
                    return false
                }
                return true
            })
        case .byLongitude:
            self.sort(by: {
                if let longitudeLeft = $0.exifLongitude{
                    if let longitudeRight = $1.exifLongitude{
                        return longitudeLeft < longitudeRight
                    }
                    return false
                }
                return true
            })
        case .byAltitude:
            self.sort(by: {
                if let altitudeLeft = $0.exifAltitude{
                    if let altitudeRight = $1.exifAltitude{
                        return altitudeLeft < altitudeRight
                    }
                    return false
                }
                return true
            })
        }
        if !ascending{
            self.reverse()
        }
    }
    
}

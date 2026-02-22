/*
 File Panels
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

class ImageExifData{
    
    static func getExifData(from url: URL) -> ImageExifData?{
        let exifData = ImageExifData()
        if exifData.load(url: url){
            return exifData
        }
        return nil
    }
    
    var exifLensModel = ""
    var exifWidth : Int = 0
    var exifHeight : Int = 0
    var exifLatitude: Double? = nil
    var exifLongitude: Double? = nil
    var exifAltitude: Double? = nil
    var exifCreationDate : Date? = nil
    
    var hasGPSData: Bool{
        return exifLatitude != nil && exifLongitude != nil
    }
    
    var hasValidGPSData: Bool{
        if let latitude = exifLatitude, let longitude = exifLongitude{
            return latitude != 0.0 || longitude != 0.0
        }
        return false
    }
    
    func load(url: URL) -> Bool{
        if let data = FileManager.default.readFile(url: url){
            if let dict = data.getExifData(){
                if let exif = dict["{Exif}"] as? NSDictionary{
                    exifLensModel = exif["LensModel"] as? String ?? ""
                    exifWidth = exif["PixelXDimension"] as? Int ?? 0
                    exifHeight = exif["PixelYDimension"] as? Int ?? 0
                    if let dateString = exif["DateTimeOriginal"] as? String{
                        exifCreationDate = DateFormats.exifDateFormatter.date(from: dateString)
                    }
                }
                if let gps = dict["{GPS}"] as? NSDictionary{
                    exifLongitude = gps["Longitude"] as? Double ?? 0.0
                    exifLatitude = gps["Latitude"] as? Double ?? 0.0
                    exifAltitude = floor(gps["Altitude"] as? Double ?? 0.0)
                }
                return true
            }
        }
        return false
    }
    
    func modifyExif(dict: NSMutableDictionary) {
        if exifCreationDate != nil{
            var exifDict: NSMutableDictionary
            if let  currentExifDict = dict.value(forKey: kCGImagePropertyExifDictionary as String) as? NSMutableDictionary{
                exifDict = currentExifDict
            }
            else{
                exifDict = NSMutableDictionary()
                dict[kCGImagePropertyExifDictionary] = exifDict
            }
            if let dateTime = exifCreationDate{
                exifDict[kCGImagePropertyExifDateTimeOriginal] = DateFormats.exifDateFormatter.string(for: dateTime)
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
            if exifAltitude != nil {
                gpsDict[kCGImagePropertyGPSAltitude] = exifAltitude
            }
            if exifLatitude != nil {
                gpsDict[kCGImagePropertyGPSLatitude] = exifLatitude
            }
            if exifLongitude != nil{
                gpsDict[kCGImagePropertyGPSLongitude] = exifLongitude
            }
        }
    }
    
}



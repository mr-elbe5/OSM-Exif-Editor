/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import SwiftUI
import Photos

@Observable class CurrentImage: NSObject{
    
    static var shared = CurrentImage()
    
    static let dummyDate = Date(timeIntervalSince1970: 0)
    
    var imageData: ImageData? = nil
    
    var dateTime : Date = CurrentImage.dummyDate
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var altitude : Double = 0.0
    
    var coordinate: CLLocationCoordinate2D?{
        if latitude != 0.0, longitude != 0.0{
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
    
    var hasChanged: Bool{
        if let imageData = imageData{
            return imageData.dateTime != self.dateTime || imageData.latitude != self.latitude || imageData.longitude != self.longitude || imageData.altitude != self.altitude
        }
        else{
            return false
        }
    }
    
    func reset(){
        imageData = nil
        dateTime = CurrentImage.dummyDate
        latitude = 0.0
        longitude = 0.0
        altitude = 0.0
    }
    
    func setImageData(_ data: ImageData){
        //debugPrint(data.metaData)
        imageData = data
        dateTime = data.dateTime ?? CurrentImage.dummyDate
        latitude = data.latitude ?? 0.0
        longitude = data.longitude ?? 0.0
        altitude = data.altitude ?? 0.0
    }
    
    func updateImageData() -> Bool{
        if let imageData = imageData{
            imageData.dateTime = dateTime == CurrentImage.dummyDate ? nil : dateTime
            imageData.latitude = latitude  == 0.0 ? nil : latitude
            imageData.longitude = longitude == 0.0 ? nil : longitude
            imageData.altitude = altitude == 0.0 ? nil : altitude
            return imageData.saveFile()
        }
        return false
    }
    
}

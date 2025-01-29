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
    
    var imageData: ImageData? = nil
    
    var dateTime : Date = Date()
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
        dateTime = Date()
        latitude = 0.0
        longitude = 0.0
        altitude = 0.0
    }
    
    func setImageData(_ data: ImageData?){
        //debugPrint(data.metaData)
        if let data = data{
            imageData = data
            dateTime = data.dateTime ?? Date()
            latitude = data.latitude ?? 0.0
            longitude = data.longitude ?? 0.0
            altitude = data.altitude ?? 0.0
        }
        else{
            reset()
        }
    }
    
    func updateImageData(updateCreation: Bool = false) -> Bool{
        if let imageData = imageData{
            imageData.dateTime = dateTime
            imageData.latitude = latitude  == 0.0 ? nil : latitude
            imageData.longitude = longitude == 0.0 ? nil : longitude
            imageData.altitude = altitude == 0.0 ? nil : altitude
            return imageData.saveFile(updateCreation: updateCreation)
        }
        return false
    }
    
}

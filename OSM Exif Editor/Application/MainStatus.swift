/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import SwiftUI
import Photos

@Observable class MainStatus: NSObject{
    
    static var shared = MainStatus()
    
    var currentImage: ImageData? = nil
    
    var dateTime : Date = Date()
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var altitude : Double = 0.0
    
    func reset(){
        currentImage = nil
        dateTime = Date()
        latitude = 0.0
        longitude = 0.0
        altitude = 0.0
    }
    
    func setImageData(_ data: ImageData){
        debugPrint(data.metaData)
        currentImage = data
        dateTime = data.dateTime ?? Date()
        latitude = data.latitude ?? 0.0
        longitude = data.longitude ?? 0.0
        altitude = data.altitude ?? 0.0
    }
    
}

/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import SwiftUI

@Observable class ExifClipboard: NSObject{
    
    static var shared = ExifClipboard()
    
    var dateTime : Date = Date()
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var altitude : Double = 0.0
    
    func copyDate() {
        dateTime = CurrentImage.shared.dateTime
    }
    
    func copyLocation() {
        latitude = CurrentImage.shared.latitude
        longitude = CurrentImage.shared.longitude
        altitude = CurrentImage.shared.altitude
    }
    
    func pasteDate() {
        CurrentImage.shared.dateTime = dateTime
    }
    
    func pasteLocation() {
        CurrentImage.shared.latitude = latitude
        CurrentImage.shared.longitude = longitude
        CurrentImage.shared.altitude = altitude
    }
    
}

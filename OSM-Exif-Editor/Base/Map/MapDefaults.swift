/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation

class MapDefaults{
    
    static var osmLink = "https://www.openstreetmap.org/copyright"
    
    static var elbe5ElevationUrl = "https://gdalserver.elbe5.de/elevation?latitude={lat}&longitude={lon}"
    
    static var mapImageIcon = NSImage(named: "mappin.red")!
    static var mapTrackIcon = NSImage(named: "mappin.blue")!
    
    static var startLocation = CLLocation(latitude: 47.42, longitude: 10.98)
    static var startZoom: Int = 14
    
}

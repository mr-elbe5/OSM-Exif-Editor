/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

class MapDefaults{
    
    static var elbe5Url = "https://maps.elbe5.de/carto/{z}/{x}/{y}.png"
    static var elbe5TopoUrl = "https://maps.elbe5.de/topo/{z}/{x}/{y}.png"
    static var osmUrl = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
    
    static var elbe5ElevationUrl = "https://gdalserver.elbe5.de/elevation?latitude={lat}&longitude={lon}"
    
    static var defaultTrackpointInterval: Double = 5.0
    static var defaultMaxHorizontalUncertainty: Double = 10.0
    
    static var defaultMinHorizontalTrackpointDistance: Double = 10.0
    static var minVerticalTrackpointDistance: Double = 5.0
    static var maxTrackpointInLineDeviation: Double = 3.0
    static var defaultMaxLocationMergeDistance: Double = 10.0
    
    static var defaultMaxSearchResults: Int = 5
    
    static var defaultDeleteLocalDataOnDownload = false
    static var defaultDeleteICloudDataOnUpload = true
    
    static var previewSize: CGFloat = 100
    
    static var startCoordinate = CLLocationCoordinate2D(latitude: 55.0, longitude: 11.5)
    static var startZoom: Int = 8
    
}

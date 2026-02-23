/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation

class TrackItem: MapItem{
    
    static func == (lhs: TrackItem, rhs: TrackItem) -> Bool {
        lhs.id == rhs.id
    }
    
    var track : Track
    
    override var coordinate: CLLocationCoordinate2D{
        get{
            track.startCoordinate ?? .zero
        }
        set {
            super.coordinate = newValue
        }
    }
    
    var coordinateRegion: CoordinateRegion?{
        var reg = track.coordinateRegion
        if reg == nil || reg == .zero{
            track.updateCoordinateRegion()
            reg = track.coordinateRegion
        }
        return reg
    }
    
    override init(){
        track = Track()
        super.init()
    }
    
    init(track: Track){
        self.track = track
        super.init()
    }
    
}

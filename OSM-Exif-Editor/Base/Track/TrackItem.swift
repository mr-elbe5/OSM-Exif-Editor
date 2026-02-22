/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation

class TrackItem: MapItem{
    
    static var itemType: String = "track"
    
    static func == (lhs: TrackItem, rhs: TrackItem) -> Bool {
        lhs.id == rhs.id
    }
    
    var track : Track
    
    override var itemType: String{
        TrackItem.itemType
    }
    
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

typealias TrackItemList = MappointList<TrackItem>

extension TrackItemList{
    
    mutating func sortByDate(ascending: Bool){
        if ascending{
            self.sort(by: { $0.creationDate < $1.creationDate})
        }
        else{
            self.sort(by: { $0.creationDate > $1.creationDate})
        }
    }
    
    func findClosestTrackpoint(to coordinate: CLLocationCoordinate2D, maxMeterDiff: Double = 100) -> (Mappoint, Double)? {
        var result: (Mappoint, Double)?
        for item in self {
            if let closests = item.track.trackpoints.findNearestPoint(to: coordinate){
                if closests.1 < (result?.1 ?? Double.greatestFiniteMagnitude){
                    result = closests
                }
            }
        }
        if let result = result, result.1 > maxMeterDiff{
            return nil
        }
        return result
    }
    
    func findClosestTrackpoint(at date: Date, maxMinDiff: Double = 60) -> (Mappoint, TimeInterval)?{
        var result: (Mappoint, Double)?
        for item in self {
            if let closests = item.track.trackpoints.findClosestPoint(to: date){
                if closests.1 < (result?.1 ?? Double.greatestFiniteMagnitude){
                    result = closests
                }
            }
        }
        // distance must be less than 1h
        if let result = result, result.1 > maxMinDiff*60{
            return nil
        }
        return result
    }
    
}

/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation

class Trackpoint{
    
    var latitude: Double
    var longitude: Double
    var altitude: Double? = nil
    var timestamp: Date? = nil
    
    var worldPoint: CGPoint{
        CGPoint(coordinate)
    }
    
    var coordinate: CLLocationCoordinate2D{
        get{
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set{
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    var gpxString: String
    {
        var str = """
        
                    <trkpt lat="\(String(format:"%.7f", latitude))" lon="\(String(format:"%.7f", longitude))">
        """
        if let alt = altitude{
            str += "<ele>\(String(format: "%.1f", alt))</ele>"
        }
        if let time = timestamp{
            str += "<time>\(time.isoString())</time>"
        }
        str += "</trkpt>"
        return str
    }
    
    init(latitude: Double, longitude: Double, altitude: Double? = nil, timestamp: Date? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
    }
    
    init(coordinate: CLLocationCoordinate2D, altitude: Double? = nil, timestamp: Date? = nil) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.altitude = altitude
        self.timestamp = timestamp
    }
    
}

extension Trackpoint{
    
    static func getTrackpointBetween(pnt1: Trackpoint, pnt2: Trackpoint) -> Trackpoint{
        let newLatitude = (pnt1.coordinate.latitude + pnt2.coordinate.latitude)/2
        let newLongitude = (pnt1.coordinate.longitude + pnt2.coordinate.longitude)/2
        var newAltitude:Double? = nil
        if let alt1 = pnt1.altitude, let alt2 = pnt2.altitude{
            newAltitude = (alt1 + alt2)/2
        }
        var newTimestamp: Date? = nil
        if let t1 = pnt1.timestamp, let t2 = pnt2.timestamp{
            newTimestamp = Date(timeIntervalSince1970: (t1.timeIntervalSince1970 + t2.timeIntervalSince1970)/2)
        }
        return Trackpoint(coordinate: CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude), altitude: newAltitude, timestamp: newTimestamp)
    }
    
}

typealias TrackpointList = [Trackpoint]

extension TrackpointList{
    
    var boundingCoordinates: (topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D)?{
        get{
            if isEmpty{
                return nil
            }
            var top = self[0].latitude
            var bottom = self[0].latitude
            var left = self[0].longitude
            var right = self[0].longitude
            for i in 1..<count{
                top = Swift.max(top, self[i].latitude)
                bottom = Swift.min(bottom, self[i].latitude)
                left = Swift.min(left, self[i].longitude)
                right = Swift.max(right, self[i].longitude)
            }
            return (topLeft: CLLocationCoordinate2D(latitude: top,longitude: left),
                    bottomRight: CLLocationCoordinate2D(latitude: bottom,longitude: right))
        }
    }
    
    var coordinateRegion: CoordinateRegion{
        if let boundingCoordinates = boundingCoordinates{
            return CoordinateRegion(topLeft: boundingCoordinates.topLeft, bottomRight: boundingCoordinates.bottomRight)
        }
        return CoordinateRegion()
    }
    
    var boundingMapRect: CGRect?{
        if let boundingCoordinates = boundingCoordinates{
            let topLeftPoint: CGPoint = World.worldPoint(coordinate: boundingCoordinates.topLeft)
            let bottomRightPoint: CGPoint = World.worldPoint(coordinate: boundingCoordinates.bottomRight)
            
            return CGRect(x: topLeftPoint.x, y: topLeftPoint.y, width: bottomRightPoint.x - topLeftPoint.x, height: bottomRightPoint.y - topLeftPoint.y)
        }
        return nil
    }
    
    func findNearestPoint(to coordinate: CLLocationCoordinate2D) -> (Trackpoint, Double)? {
        var nearestPoint: Trackpoint?
        var minDistance: Double?
        for point in self {
            let distance = point.coordinate.distance(to: coordinate)
            if minDistance == nil || distance < minDistance! {
                nearestPoint = point
                minDistance = distance
            }
        }
        if let tp = nearestPoint, let dist = minDistance {
            return (tp, dist)
        }
        return nil
    }
    
    func findClosestPoint(to date: Date) -> (Trackpoint, TimeInterval)?{
        var closestPoint: Trackpoint?
        var minTimeDiff: TimeInterval?
        for point in self {
            if let timestamp = point.timestamp {
                let diff = abs(timestamp.distance(to: date))
                if minTimeDiff == nil || diff < minTimeDiff! {
                    closestPoint = point
                    minTimeDiff = diff
                }
            }
            
        }
        if let point = closestPoint, let diff = minTimeDiff {
            return (point, diff)
        }
        return nil
    }
    
}

/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

class Mappoint: Equatable{
    
    static var zero = Mappoint(coordinate: .zero)
    
    static func == (lhs: Mappoint, rhs: Mappoint) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
    
    var latitude: Double
    var longitude: Double
    var altitude: Double? = nil
    var timestamp: Date? = nil
    
    //runtime
    var selected: Bool = false
    
    var coordinate: CLLocationCoordinate2D{
        get{
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set{
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    var location: CLLocation{
        get{
            if let altitude = altitude{
                if let timestamp = timestamp{
                    return CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: timestamp)
                }
                return CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: Date.zero)
            }
            return CLLocation(latitude: latitude, longitude: longitude)
        }
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
    
    init(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.altitude = location.altitude
        self.timestamp = location.timestamp
    }
    
}


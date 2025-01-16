/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

extension CLLocationCoordinate2D : @retroactive Equatable{
    
    static var equatorMeters = 40075017.0
    static var circleMeters = 40007863.0
    
    static var equatorMetersPerDegree = equatorMeters/360
    static var circleMetersPerDegree = circleMeters/360
    
    static var degreeToRadFactor = Double.pi/180
    
    static public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    var asString : String{
        let latitudeText = latitude > 0 ? "north".localize(table: "Location") : "south".localize(table: "Location")
        let longitudeText = longitude > 0 ? "east".localize(table: "Location") : "west".localize(table: "Location")
        return String(format: "%.04f", abs(latitude)) + "° " + latitudeText + ", " + String(format: "%.04f", abs(longitude)) + "° "  + longitudeText
    }
    
    var asShortString : String{
        let latitudeText = latitude > 0 ? "northShort".localize(table: "Location") : "southShort".localize(table: "Location")
        let longitudeText = longitude > 0 ? "eastShort".localize(table: "Location") : "westShort".localize(table: "Location")
        return String(format: "%.04f", abs(latitude)) + "° " + latitudeText + ", " + String(format: "%.04f", abs(longitude)) + "° "  + longitudeText
    }
    
    var debugString : String{
        "lat: \(String(format: "%.7f", latitude)), lon: \(String(format: "%.7f", longitude))"
    }
    
}

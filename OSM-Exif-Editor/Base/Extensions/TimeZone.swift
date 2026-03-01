//
//  ZoneList+Json.swift
//  OSM-Exif-Editor
//
//  Created by Michael Rönnau on 28.02.26.
//

import Foundation
import CoreLocation

extension TimeZone{
    
    static func getTimeZoneAsync(coordinate: CLLocationCoordinate2D, result: @escaping (TimeZone) -> Void){
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)){ (placemarks, error) in
            if let error = error{
                Log.error(error: error)
                result(.current)
                return
            }
            if let placemark =  placemarks?[0]{
                //Log.debug("got placemark")
                result(placemark.timeZone ?? .current)
            }
            else{
                Log.debug("no placemark found")
                result(.current)
            }
        }
    }
    
}

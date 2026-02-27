/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

extension TimeZone{

    static func getTimeZone(coordinate: CLLocationCoordinate2D, result: @escaping (TimeZone?) -> Void){
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)){ (placemarks, error) in
            if let error = error{
                Log.error(error: error)
                result(nil)
                return
            }
            if let placemark =  placemarks?[0]{
                Log.debug("got placemark")
                result(placemark.timeZone)
            }
            else{
                Log.debug("no placemark")
                result(nil)
            }
        }
    }
    
}

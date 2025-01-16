/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

extension CLPlacemark{
    
    static func getPlacemark(for coordinate: CLLocationCoordinate2D, result: @escaping(CLPlacemark?) -> Void){
        getPlacemark(for: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), result: result)
    }
    
    static func getPlacemark(for location: CLLocation, result: @escaping(CLPlacemark?) -> Void){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let error = error{
                debugPrint(error)
                result(nil)
                return
            }
            if let placemark =  placemarks?[0]{
                //debugPrint("got placemark")
                result(placemark)
            }
            else{
                //debugPrint("no placemark")
                result(nil)
            }
        })
    }
    
    static func getPlacemarkName(for coordinate: CLLocationCoordinate2D, result: @escaping(String) -> Void){
        getPlacemarkName(for: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), result: result)
    }
    
    static func getPlacemarkName(for location: CLLocation, result: @escaping(String) -> Void){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let error = error{
                debugPrint(error)
                result("")
                return
            }
            if let placemark =  placemarks?[0]{
                //debugPrint("got placemark")
                result(placemark.asString)
            }
            else{
                //debugPrint("no placemark")
                result("")
            }
        })
    }
    
    var nameString: String?{
        if let name = name{
            if name.isEmpty || name == postalCode{
                return nil
            }
            else{
                return name
            }
        }
        return nil
    }
    
    var locationString: String{
        let streetAddress = "\(thoroughfare ?? "") \(subThoroughfare ?? "")".trim()
        return streetAddress.isEmpty ?
        "\(postalCode ?? "") \(locality ?? "")\n\(country ?? "")" :
        "\(streetAddress)\n\(postalCode ?? "") \(locality ?? "")\n\(country ?? "")"
    }
    
    var asString: String{
        if let name = name, !name.isEmpty{
            return name
        }
        return locationString
    }
    
}

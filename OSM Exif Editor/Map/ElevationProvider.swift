/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation

class ElevationProvider{
    
    static var shared = ElevationProvider()
    
    func getElevation(at coordinate: CLLocationCoordinate2D, result: @escaping (Double) -> Void) {
        if let url = URL(string: Preferences.shared.elevationUrl.replacing("{lat}", with: String(coordinate.latitude)).replacing("{lon}", with: String(coordinate.longitude))){
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
            let task = getElevationTask(request: request, result: result)
            DispatchQueue.global(qos: .userInitiated).async{
                debugPrint("getting elevation")
                task.resume()
            }
        }
        else {
            result(0)
        }
    }
    
    private func getElevationTask(request: URLRequest, result: @escaping (Double) -> Void) -> URLSessionDataTask{
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            var statusCode = 0
            if (response != nil && response is HTTPURLResponse){
                let httpResponse = response! as! HTTPURLResponse
                statusCode = httpResponse.statusCode
            }
            if statusCode == 200, let data = data, let string = String(data: data, encoding: .utf8), let elevation = Double(string){
                debugPrint("ElevationProvider got elevation \(elevation)")
                result(elevation)
                return
            }
            if let err = err {
                switch (err as? URLError)?.code {
                case .some(.timedOut):
                    debugPrint("ElevationProvider timeout getting elevation, error: \(err.localizedDescription)")
                default:
                    debugPrint("ElevationProvider getting elevation failed, error: \(err.localizedDescription)")
                }
            }
            else{
                debugPrint("ElevationProvider getting elevation , statusCode=\(statusCode)")
            }
            result(0)
        }
    }
    
}

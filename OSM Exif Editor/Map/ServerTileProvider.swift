/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

class ServerTileProvider: TileProvider{
    
    override func loadTileImage(tile: MapTile, result: @escaping (Bool) -> Void) {
        if !tile.valid {
            result(false)
            return
        }
        let request = URLRequest(url: tile.tileUrl(template: Preferences.shared.urlTemplate), cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        let task = getDownloadTask(request: request, tile: tile, tries: 1, result: result)
        DispatchQueue.global(qos: .userInitiated).async{
            //debugPrint("loading remote tile")
            task.resume()
        }
    }
    
    private func retryLoadTileImage(tile: MapTile, tries: Int, result: @escaping (Bool) -> Void) {
        let request = URLRequest(url: tile.tileUrl(template: Preferences.shared.urlTemplate), cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 20.0)
        let task = getDownloadTask(request: request, tile: tile, tries: tries, result: result)
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 5){
            task.resume()
        }
    }
    
    private func getDownloadTask(request: URLRequest, tile: MapTile, tries: Int, result: @escaping (Bool) -> Void) -> URLSessionDataTask{
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            var statusCode = 0
            if (response != nil && response is HTTPURLResponse){
                let httpResponse = response! as! HTTPURLResponse
                statusCode = httpResponse.statusCode
            }
            if statusCode == 200, let data = data{
                //debugPrint("TileProvider loaded tile \(tile.shortDescription)")
                if tries > 1{
                    //debugPrint("TileProvider got tile in try \(tries)")
                }
                self.tileCache[tile.shortDescription] = data
                if !self.saveTile(fileUrl: tile.fileUrl, data: data){
                    debugPrint("TileProvider could not save tile \(tile.shortDescription)")
                }
                tile.imageData = data
                result(true)
                return
            }
            if let err = err {
                switch (err as? URLError)?.code {
                case .some(.timedOut):
                    debugPrint("TileProvider timeout loading tile, error: \(err.localizedDescription)")
                default:
                    debugPrint("TileProvider loading tile, error: \(err.localizedDescription)")
                }
            }
            else{
                //debugPrint("TileProvider loading tile \(tile.shortDescription), statusCode=\(statusCode)")
            }
            if tries <= ServerTileProvider.maxTries{
                self.retryLoadTileImage(tile: tile, tries: tries + 1){ success in
                    result(success)
                }
            }
            
        }
    }
    
}

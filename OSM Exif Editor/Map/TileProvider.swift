/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class TileProvider{
    
    static var shared: TileProvider? = nil
    
    static let maxTries: Int = 3
    
    var tileCache = Dictionary<String, Data>()
    
    func getTileImage(tile: MapTile, result: @escaping (Bool) -> Void) {
        if !tile.valid {
            return
        }
        if let data = tileCache[tile.shortDescription] {
            tile.imageData = data
            //debugPrint("got cached tile")
            result(true)
            return
        }
        if tile.exists, let fileData = FileManager.default.contents(atPath: tile.fileUrl.path){
            //debugPrint("got local tile")
            tileCache[tile.shortDescription] = fileData
            tile.imageData = fileData
            result(true)
        } else {
            //debugPrint("loading tile")
            loadTileImage(tile: tile, result: result)
        }
    }
    
    private func getTileFromCache(name: String) -> Data? {
        tileCache[name]
    }
    
    func loadTileImage(tile: MapTile, result: @escaping (Bool) -> Void){
        
    }
    
    func saveTile(fileUrl: URL, data: Data?) -> Bool{
        if let data = data{
            do{
                try data.write(to: fileUrl, options: .atomic)
                //debug("TileProvider file saved to \(fileUrl)")
                return true
            } catch let err{
                debugPrint("TileProvider saving tile: " + err.localizedDescription)
                return false
            }
        }
        return false
    }
    
    func deleteAllTiles(){
        do{
            try FileManager.default.removeItem(at: FileManager.tileDirURL)
            try FileManager.default.createDirectory(at: FileManager.tileDirURL, withIntermediateDirectories: true)
            tileCache.removeAll()
            //debugPrint("TileProvider tile directory cleared")
        }
        catch let err{
            debugPrint("TileProvider deleting files: ", err)
        }
    }
    
    func dumpTiles(){
        var paths = Array<String>()
        if let subpaths = FileManager.default.subpaths(atPath: FileManager.tileDirURL.path){
            for path in subpaths{
                paths.append(path)
            }
            paths.sort()
        }
        for path in paths{
            print(path)
        }
    }
    
}

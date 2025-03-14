/*
 E5MapData
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

class MapTile{
    
    static func getTile(data: MapTileData) -> MapTile{
        let tile = MapTile(zoom: data.zoom, x: data.x, y: data.y)
        //Log.debug("get tile \(tile.shortDescription)")
        if tile.exists, let fileData = FileManager.default.contents(atPath: tile.fileUrl.path){
            tile.imageData = fileData
        }
        return tile
    }

    static var tilesDirURL: URL = FileManager.default.urls(for: .applicationSupportDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!.appendingPathComponent("tiles")
    
    var x: Int
    var y: Int
    var zoom: Int
    
    var imageData : Data? = nil
    
    init(zoom: Int, x: Int, y: Int){
        self.zoom = zoom
        self.x = x
        self.y = y
    }
    
    var valid: Bool{
        zoom >= 0 && zoom <= 18 && x >= 0 && y >= 0
    }
    
    var fileUrl: URL{
        MapTile.tilesDirURL.appendingPathComponent("\(shortDescription).png")
    }
    
    var exists: Bool{
        FileManager.default.fileExists(atPath: fileUrl.path)
    }
    
    var shortDescription : String{
        "\(zoom)-\(x)-\(y)"
    }
    
    func tileUrl(template: String) -> URL{
        URL(string: template.replacingOccurrences(of: "{z}", with: String(zoom)).replacingOccurrences(of: "{x}", with: String(x)).replacingOccurrences(of: "{y}", with: String(y)))!
    }
    
}

struct MapTileData{
    
    init(zoom: Int, x: Int, y: Int) {
        self.zoom = zoom
        self.x = x
        self.y = y
    }
    
    var zoom: Int
    var x: Int
    var y: Int
    
}

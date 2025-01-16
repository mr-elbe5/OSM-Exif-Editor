/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

#if os(macOS)
import AppKit
#else
import UIKit
#endif

@Observable class MapTile{
    
    let x: Int
    let y: Int
    let zoom: Int
    
    var imageData : Data? = nil
    
    init(){
        x = 0
        y = 0
        zoom = World.minZoom
    }
    
    init(zoom: Int, x: Int, y: Int){
        self.zoom = zoom
        self.x = x
        self.y = y
    }
    
    var valid: Bool{
        zoom >= 0 && zoom <= 18 && x >= 0 && y >= 0
    }
    
    var fileUrl: URL{
        FileManager.tileDirURL.appendingPathComponent("\(shortDescription).png")
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

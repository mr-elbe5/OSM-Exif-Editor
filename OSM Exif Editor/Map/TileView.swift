/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI
import AppKit

struct TileView: View {
    
    var mapTile: MapTile
    
    init(mapTile: MapTile) {
        self.mapTile = mapTile
    }
    
    var body: some View {
        if let image = getImage(){
            Image(nsImage: image)
                .resizable()
        }
        else{
            Image("gear.grey")
                .resizable()
        }
    }
    
    func getImage() -> NSImage?{
        if let imageData = mapTile.imageData{
            return NSImage(data: imageData)
        }
        return nil
    }
    
}
    

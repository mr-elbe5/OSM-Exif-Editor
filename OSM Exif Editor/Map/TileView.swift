/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

struct TileView: View {
    
    var mapTile: MapTile
    
    init(mapTile: MapTile) {
        self.mapTile = mapTile
    }
    
    var body: some View {
        if let image = getImage(){
#if os(macOS)
            Image(nsImage: image)
                .resizable()
#else
            Image(uiImage: image)
                .resizable()
#endif
        }
        else{
            Image("gear.grey")
                .resizable()
        }
    }
    
    func getImage() -> OSImage?{
        if let imageData = mapTile.imageData{
            return OSImage(data: imageData)
        }
        return nil
    }
    
}
    

/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct ImageCellView: View {
    
    @State var mainStatus: MainStatus = MainStatus.shared
    @State var imageData : ImageData
    
    var body: some View {
        Button(action: {
            mainStatus.setImageData(imageData)
            if let coordinate = imageData.coordinate{
                if MapStatus.shared.zoom < 10 {
                    MapStatus.shared.zoom = 14
                }
                MapStatus.shared.centerCoordinate = coordinate
                MapTileGrid.shared.update()
            }
        }, label: {
            Image(nsImage: imageData.getPreview())
            .resizable()
            .scaledToFit()}
        )
        .buttonStyle(PlainButtonStyle())
    }
    
    func getImage() -> NSImage? {
        debugPrint("using image \(imageData.url)")
        return imageData.preview
    }
    
}


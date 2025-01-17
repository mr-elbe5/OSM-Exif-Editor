/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct ImageCellView: View {
    
    @State var imageItem : ImageItem
    
    var body: some View {
        if let image = getImage() {
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
        }
    }
    
    func getImage() -> NSImage? {
        debugPrint("using image \(imageItem.fileURL)")
        return imageItem.getImage()
    }
    
}


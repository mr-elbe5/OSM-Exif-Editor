/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct ImageCellView: View {
    
    @State var imageItem : ImageData
    
    var body: some View {
        if let image = getImage() {
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
        }
    }
    
    func getImage() -> NSImage? {
        debugPrint("using image \(imageItem.fileName)")
        return imageItem.getImage()
    }
    
}


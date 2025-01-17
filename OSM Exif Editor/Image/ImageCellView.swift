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
            Image(osImage: image)
                .resizable()
                .scaledToFit()
        }
    }
    
    func getImage() -> OSImage? {
        debugPrint("using image \(imageItem.fileURL)")
        return imageItem.getImage()
    }
    
}


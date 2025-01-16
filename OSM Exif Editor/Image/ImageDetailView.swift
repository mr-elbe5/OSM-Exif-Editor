/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct ImageDetailView: View {
    
    @State var imageItem: ImageItem
    
    var body: some View {
        if let image = imageItem.getImage() {
            Image(osImage: image)
                .resizable()
                .scaledToFit()
        }
    }
    
}
    

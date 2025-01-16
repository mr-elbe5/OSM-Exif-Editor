/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI
import PhotosUI

struct ImagesView: View {
    
    @State var imageItems: ImageItemList = ApplicationData.shared.imageList
    
    var body: some View {
        List {
            ForEach(imageItems, id: \.id) { item in
                ImageView(imageItem: item)
            }
        }
        
    }
    
}
    
#Preview {
    ImagesView()
}

/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct ImageDetailView: View {
    
    @State var mainStatus = MainStatus.shared
    
    var body: some View {
        VStack{
            if let item = mainStatus.currentImage, let image = item.getImage() {
                Image(osImage: image)
                    .resizable()
                    .scaledToFit()
            }
            else{
                Image("gear.grey")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
    
}
    

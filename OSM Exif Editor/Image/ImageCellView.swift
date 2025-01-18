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
        if let image = getImage() {
            Button(action: {
                mainStatus.currentImage = imageData
            }, label: {Image(nsImage: image)
                .resizable()
                .scaledToFit()}
            )
            .buttonStyle(PlainButtonStyle())
            .frame(width: .infinity)
        }
    }
    
    func getImage() -> NSImage? {
        debugPrint("using image \(imageData.fileName)")
        return imageData.getImage()
    }
    
}


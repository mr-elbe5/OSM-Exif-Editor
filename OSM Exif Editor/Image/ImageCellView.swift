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
            ZStack(alignment: .center){
            Color(.darkGray)
                .cornerRadius(10)
            VStack{
                if let dateTime = imageData.metaData.dateTime{
                    Text(dateTime.exifString)
                        .foregroundColor(.white)
                }

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
                        .scaledToFit()
                    
                })
                .padding(10)
                
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    @Previewable @State var imageData = ImageData(url: URL(fileURLWithPath: ""))
    imageData.metaData.dateTime = Date()
    imageData.metaData.latitude = 32.6514
    imageData.metaData.longitude = 61.4333
    return ImageCellView(imageData: imageData)
}

/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct ImageCellView: View {
    
    @State var mainStatus: CurrentImage = CurrentImage.shared
    @State var imageData : ImageData
    
    var body: some View {
        ZStack(alignment: .center){
            Color(.darkGray)
                .cornerRadius(10)
            
            Button(action: {
                mainStatus.setImageData(imageData)
                if let coordinate = imageData.coordinate{
                    if MapStatus.shared.zoom < 10 {
                        MapStatus.shared.zoom = 14
                    }
                    MapStatus.shared.centerCoordinate = coordinate
                    MapTiles.shared.update()
                }
            }, label: {
                Image(nsImage: imageData.getPreview())
                    .resizable()
                    .scaledToFit()
                
            })
            .buttonStyle(PlainButtonStyle())
            .padding(20)
            
            if let dateTime = imageData.dateTime{
                Text(dateTime.exifString)
                    .offset(y: -ImageGridView.cellSize/2 + 15)
            }
            
            if imageData.coordinate != nil{
                Image(systemName: "map")
                    .offset(x: ImageGridView.cellSize/2 - 15, y: ImageGridView.cellSize/2 - 15)
            }
        }
        
    }
}


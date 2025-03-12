/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct ImageCellView: View {
    
    @State var currentImage: CurrentImage = CurrentImage.shared
    @State var imageData : ImageData
    
    var body: some View {
        Button(action: {
            if imageData == currentImage.imageData{
                currentImage.setImageData(nil)
            }
            else{
                currentImage.setImageData(imageData)
                if let coordinate = imageData.coordinate{
                    if MapStatus.shared.zoom < 10 {
                        MapStatus.shared.zoom = 14
                    }
                    MapStatus.shared.centerCoordinate = coordinate
                    MapTiles.shared.update()
                }
            }
        }, label: {
            ZStack(alignment: .center){
                Color(backgroundColor)
                    .cornerRadius(10)
                Image(nsImage: imageData.getPreview())
                    .resizable()
                    .scaledToFit()
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
        })
        .buttonStyle(PlainButtonStyle())
        
        
        var backgroundColor : NSColor {
            if currentImage.imageData?.id == imageData.id{
                return .lightGray
            }else{
                return .darkGray
            }
        }
        
    }
}


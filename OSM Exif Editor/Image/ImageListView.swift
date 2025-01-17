/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI
import PhotosUI

struct ImageListView: View {
    
    @State var imageItems: ImageItemList = ApplicationData.shared.imageList
    
    var body: some View {
        VStack {
            Button(action: {
                selectImages()
            }, label: {Text("Select Images")}
            )
            .padding()
            List {
                ForEach(imageItems, id: \.id) { item in
                    ImageCellView(imageItem: item)
                }
            }
            .padding()
        }
        
    }
    
    func selectImages(){
        
    }
}
    
#Preview {
    ImageListView()
}

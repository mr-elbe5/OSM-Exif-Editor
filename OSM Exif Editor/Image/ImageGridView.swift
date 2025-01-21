/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct ImageGridView: View {
    
    static let cellSize: CGFloat = 200

    @State var appData: ApplicationData = ApplicationData.shared
    
    var body: some View {
        
        let columns = [
            GridItem(.adaptive(minimum: ImageGridView.cellSize))
            ]
        ScrollView(){
            LazyVGrid(columns: columns){
                ForEach(appData.imageList, id: \.id) { item in
                    ImageCellView(imageData: item)
                    .frame(width: ImageGridView.cellSize, height: ImageGridView.cellSize)
                }
            }
            .padding(.all)
        }
    }
    
}

#Preview {
    ImageGridView()
}

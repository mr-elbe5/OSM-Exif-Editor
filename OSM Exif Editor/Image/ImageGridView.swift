/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct ImageGridView: View {

    @State var appData: ApplicationData = ApplicationData.shared
    
    var body: some View {
        
        let columns = [
                GridItem(.adaptive(minimum: 200))
            ]
        ScrollView(){
            LazyVGrid(columns: columns){
                ForEach(appData.imageList, id: \.id) { item in
                    ImageCellView(imageData: item)
                }
            }
            .padding(.all)
        }
    }
    
}

#Preview {
    ImageGridView()
}

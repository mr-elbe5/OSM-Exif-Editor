/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MainView: View {
    
    @State var mainStatus: MainStatus = MainStatus.shared
    
    var body: some View {
        GeometryReader { proxy in
            HStack{
                ImageListView()
                    .frame(width: 200)
                VSplitView{
                    ImageDetailView()
                        .frame(minHeight: proxy.size.height/4)
                        .frame(maxHeight: proxy.size.height*3/4)
                        .frame(maxWidth: .infinity)
                    MapContainerView()
                        .frame(minHeight: proxy.size.height/4)
                        .frame(maxHeight: proxy.size.height*3/4)
                        .frame(maxWidth: .infinity)
                }
                .frame(width: proxy.size.width - 510)
                ExifEditView()
                    .frame(width: 300)
            }
        }
    }
    
}
    
#Preview {
    MainView()
}

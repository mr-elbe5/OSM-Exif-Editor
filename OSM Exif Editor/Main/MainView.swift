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
            HSplitView{
                ImageListView()
                    .background(Color.yellow)
                    .frame(maxWidth: proxy.size.width/4)
                    .frame(minWidth: 100)
                VSplitView{
                    ImageDetailView()
                        .frame(minHeight: proxy.size.height/4)
                        .frame(maxHeight: proxy.size.height*3/4)
                    MapContainerView()
                        .frame(minHeight: proxy.size.height/4)
                        .frame(maxHeight: proxy.size.height*3/4)
                }
                ExifEditView()
                    .background(Color.green)
                    .frame(maxWidth: proxy.size.width/3)
                    .frame(minWidth: 100)
            }
        }
    }
    
}
    
#Preview {
    MainView()
}

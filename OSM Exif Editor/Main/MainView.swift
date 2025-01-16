/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MainView: View {
    
    @State var mainStatus: MainStatus = MainStatus.shared
    
    var body: some View {
        HStack{
            MapMenuView()
            GeometryReader{ proxy in
                ZStack(alignment: .center){
                    MapView()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                        .background(.red)
                    CrossButton()
                        .hide(mainStatus.hideCrossButton)
                }
                .clipped()
            }
        }
    }
    
}
    
#Preview {
    MainView()
}

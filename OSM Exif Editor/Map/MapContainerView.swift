/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MapContainerView: View {
    
    @State var mapStatus = MapStatus.shared
    
    var body: some View {
        NavigationStack {
            GeometryReader{ proxy in
                ZStack(alignment: .topLeading){
                    ZStack(alignment: .center){
                        MapBaseView()
                            .frame(width: proxy.size.width, height: proxy.size.height)
                        CrossButton()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                    ZStack(alignment: .top){
                        Button(action: {
                            mapStatus.zoomIn()
                        }, label: {Image(systemName: "plus").menuIconImage()
                            .foregroundColor(.black)}
                        )
                        .position(x: 30, y: 30)
                        Button(action: {
                            mapStatus.zoomOut()
                        }, label: {Image(systemName: "minus").menuIconImage()
                            .foregroundColor(.black)}
                        )
                        .position(x: 30, y: 80)
                    }
                }
            }
            
        }
    }
    
}
    
#Preview {
    MainView()
}

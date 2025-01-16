/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import SwiftUI

struct MapMenuView: View {
    
    @State var mapStatus = MapStatus.shared
    @State var tileGrid = MapTileGrid.shared
    @State var mainStatus = MainStatus.shared
    
    var body: some View {
        VStack(spacing: 10){
            Button(action: {
                mainStatus.hideCrossButton = !mainStatus.hideCrossButton
            }, label: {Image(systemName: "plus.circle").menuIconImage()
                .foregroundColor(CrossButton.crossIconColor)}
            )
            Button(action: {
                mapStatus.zoomIn()
                tileGrid.update()
            }, label: {Image(systemName: "plus").menuIconImage()}
            )
            Button(action: {
                mapStatus.zoomOut()
                tileGrid.update()
            }, label: {Image(systemName: "minus").menuIconImage()}
            )
            Spacer()
        }
        .padding(3)
        .zIndex(1)
    }
    
}

#Preview {
    MapMenuView()
}

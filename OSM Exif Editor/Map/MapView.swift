/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MapView: View {
    
    static let minDragOffset: CGFloat = 3
    
    @State var mapStatus = MapStatus.shared
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        MapBaseView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

#Preview {
    MapView()
}

/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MapView: View {
    
    static let minDragOffset: CGFloat = 3
    
    @State var mapStatus = MapStatus.shared
    @State var mapTiles = MapTiles.shared
    
    @State private var lastOffset: CGSize = .zero
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if abs(gesture.translation.width - lastOffset.width) > MapView.minDragOffset || abs(gesture.translation.height - lastOffset.height) > MapView.minDragOffset {
                    mapStatus.moveBy(offset: CGSize(width: gesture.translation.width - lastOffset.width, height: gesture.translation.height - lastOffset.height))
                    mapTiles.update()
                    lastOffset = gesture.translation
                }
            }
            .onEnded { gesture in
                mapStatus.moveBy(offset: CGSize(width: gesture.translation.width - lastOffset.width, height: gesture.translation.height - lastOffset.height))
                mapTiles.update()
                lastOffset = .zero
            }
    }
    
    var body: some View {
        ZStack(alignment: .center){
            VStack(alignment: .center, spacing: 0){
                ForEach(0..<mapTiles.gridHeight, id: \.self){ y in
                    HStack(alignment: .center, spacing: 0){
                        ForEach(0..<mapTiles.gridWidth, id: \.self){ x in
                            if let tile = mapTiles.getTile(x, y){
                                TileView(mapTile: tile)
                                    .frame(width: World.tileExtent, height: World.tileExtent)
                            }
                        }
                    }
                }
            }
            .offset(mapTiles.centerTileOffset)
            .gesture(dragGesture)
        }
        .background(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

#Preview {
    MapView()
}

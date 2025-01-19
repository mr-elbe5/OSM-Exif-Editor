/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MapView: View {
    
    static let minDragOffset: CGFloat = 3
    
    @State var mapStatus = MapStatus.shared
    @State var tileGrid = MapTileGrid.shared
    
    //@State var visibleItems = VisibleMapItems.shared
    
    @State private var lastOffset: CGSize = .zero
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if abs(gesture.translation.width - lastOffset.width) > MapView.minDragOffset || abs(gesture.translation.height - lastOffset.height) > MapView.minDragOffset {
                    mapStatus.moveBy(offset: CGSize(width: gesture.translation.width - lastOffset.width, height: gesture.translation.height - lastOffset.height))
                    tileGrid.update()
                    //visibleItems.update()
                    lastOffset = gesture.translation
                }
            }
            .onEnded { gesture in
                mapStatus.moveBy(offset: CGSize(width: gesture.translation.width - lastOffset.width, height: gesture.translation.height - lastOffset.height))
                tileGrid.update()
                //visibleItems.update()
                lastOffset = .zero
            }
    }
    
    var pinchGesture: some Gesture {
        MagnifyGesture()
            .onEnded { value in
                if value.magnification > 1 {
                    mapStatus.zoomIn()
                }
                else if value.magnification < 1 {
                    mapStatus.zoomOut()
                }
            }
    }
    
    var body: some View {
        ZStack(alignment: .center){
            VStack(alignment: .center, spacing: 0){
                ForEach(0..<tileGrid.gridHeight, id: \.self){ y in
                    HStack(alignment: .center, spacing: 0){
                        ForEach(0..<tileGrid.gridWidth, id: \.self){ x in
                            TileView(mapTile: tileGrid.tileGrid[y][x])
                                .frame(width: World.tileExtent, height: World.tileExtent)
                        }
                    }
                }
            }
            .offset(tileGrid.centerTileOffset)
            .gesture(dragGesture)
            .gesture(pinchGesture)
            /*ForEach(visibleItems.visibleMapItems, id: \.self){ item in
             ItemView(item: item)
             .offset(World.offset(from: AppStatus.shared.centerCoordinate, to: item.coordinate, at: AppStatus.shared.zoom))
             }
             ForEach(visibleItems.visibleItemGroups, id: \.self){ group in
             if let coordinate = group.centerCoordinate{
             GroupView(item: group)
             .offset(World.offset(from: AppStatus.shared.centerCoordinate, to: coordinate, at: AppStatus.shared.zoom))
             }
             }*/
        }
        .background(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
    
    func setPos() -> some View{
        //visibleItems.update()
        debugPrint("setting dummies")
        //ApplicationData.shared.setDummies()
        return self
    }
    
    /*struct ItemView: View{
     let item: MapItem
     var body: some View{
     switch item.type{
     case .note:
     NoteItemView(item: item as! NoteItem)
     case .image:
     ImageItemView(item: item as! ImageItem)
     case .trackStart:
     EmptyView()
     }
     }
     }*/
    
    /*struct GroupView: View{
     let item: ItemGroup
     var body: some View{
     ItemGroupView(item: item)
     }
     }*/
    
}

#Preview {
    MapView().setPos()
}

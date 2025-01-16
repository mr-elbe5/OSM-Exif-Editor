/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import SwiftUI
import CoreLocation

struct MapMenuView: View {
    
    @State var mapStatus = MapStatus.shared
    @State var tileGrid = MapTileGrid.shared
    @State var mainStatus = MainStatus.shared
    
    @State private var showDetailPopover = false
    @State private var detailText = "Unknown location"
    
    var body: some View {
        VStack(spacing: 10){
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
            Button {
                showDetails()
            } label:  {Image(systemName: "envelope.front")
                    .font(Font.system(size: 24))}
            .popover(isPresented: $showDetailPopover,
                     attachmentAnchor: .point(.trailing),
                     arrowEdge: .trailing) {
                VStack {
                    Text(detailText)
                        .font(.headline)
                        .padding(3)
                }
                .padding()
                .frame(minWidth: 200)
                .presentationCompactAdaptation(.none)
                
            }
            Spacer()
        }
        .padding(3)
        .zIndex(1)
    }
    
    func showDetails(){
        CLPlacemark.getPlacemark(for: MapStatus.shared.centerCoordinate, result: { placemark in
            if let placemark = placemark {
                self.detailText = placemark.locationString
            }
            else{
                self.detailText = "Unknown location"
            }
        })
        showDetailPopover = true
    }
    
}

#Preview {
    MapMenuView()
}

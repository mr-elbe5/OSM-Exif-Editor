/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import SwiftUI
import CoreLocation

struct CrossButton: View {
    
    static let crossIconColor = Color.blue
    
    @State private var showDetailPopover = false
    @State private var detailText = "Unknown location"
    
    var body: some View {
        Button {
            showDetails()
        } label:  {Image(systemName: "plus.circle")
                .font(Font.system(size: 24))
            .foregroundColor(CrossButton.crossIconColor)}
        .buttonStyle(.borderless)
        .popover(isPresented: $showDetailPopover,
                 attachmentAnchor: .point(.center),
                 arrowEdge: .top) {
            VStack {
                Text(detailText)
                    .font(.headline)
                    .padding(3)
                Button {
                    setImageLocation()
                } label: {
                    Text("Set Image Location")
                }
                .padding(3)
            }
            .padding()
            .frame(minWidth: 200)
            .presentationCompactAdaptation(.none)
            
        }
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
    
    func setImageLocation(){
        
    }
    
}

#Preview {
    CrossButton()
}

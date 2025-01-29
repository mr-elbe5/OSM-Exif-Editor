/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct PreferencesView: View {
    
    @State var preferences: Preferences = Preferences.shared
    @State var mapSource: String = Preferences.shared.urlTemplate
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            Picker("mapSource".localize(), selection: $mapSource) {
                Text("OSM").tag(MapDefaults.osmUrl)
                Text("Elbe5").tag(MapDefaults.elbe5Url)
                Text("Elbe5Topo").tag(MapDefaults.elbe5TopoUrl)
            }
            .padding()
            HStack{
                Button(action: {
                    self.dismiss()
                }) {
                    Text("cancel".localize())
                }
                Button(action: {
                    preferences.urlTemplate = self.mapSource
                    TileProvider.shared?.deleteAllTiles()
                    MapTiles.shared.updateTiles(force: true)
                    self.dismiss()
                }) {
                    Text("save".localize())
                }
            }
            .padding()
            
        }
        
    }
    
}
    
#Preview {
    PreferencesView()
}

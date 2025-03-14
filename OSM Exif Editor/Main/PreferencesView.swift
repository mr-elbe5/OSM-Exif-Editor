/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct PreferencesView: View {
    
    @State var preferences: Preferences = Preferences.shared
    @State var mapSource: String = Preferences.shared.urlTemplate
    @State var showTwoColumns: Bool = Preferences.shared.showTwoColumns
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            Picker("mapSource".localize(), selection: $mapSource) {
                Text("OSM").tag(MapDefaults.osmUrl)
                Text("Elbe5").tag(MapDefaults.elbe5Url)
                Text("Elbe5Topo").tag(MapDefaults.elbe5TopoUrl)
            }
            .padding(10)
            Toggle("showTwoColumns".localize(), isOn: $showTwoColumns)
                .padding(10)
            HStack{
                Button(action: {
                    self.dismiss()
                }) {
                    Text("cancel".localize())
                }
                Button(action: {
                    preferences.urlTemplate = self.mapSource
                    preferences.showTwoColumns = self.showTwoColumns
                    if !showTwoColumns {
                        ApplicationData.shared.removeAllImages(of: .right)
                    }
                    TileProvider.shared?.deleteAllTiles()
                    self.dismiss()
                }) {
                    Text("ok".localize())
                }
            }
            .padding()
            
        }
        
    }
    
}
    
#Preview {
    PreferencesView()
}

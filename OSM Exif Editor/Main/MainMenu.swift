/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MainMenu: View {

    @State var showPreferences: Bool = false
    @State var showHelp: Bool = false
    
    var body: some View {
        HStack() {
            Spacer()
            Button(action: {
                showPreferences = true
            }, label: {HStack{
                Image(systemName: "gearshape")
                Text("preferences".localize())}
            })
            .padding()
            Button(action: {
                showHelp = true
            }, label: {HStack{
                Image(systemName: "questionmark.circle")
                Text("help".localize())}
            })
            .padding(10)
        }
        .sheet(isPresented: $showPreferences) {
        } content: {
            PreferencesView()
                .frame(maxWidth: 300)
        }
        .sheet(isPresented: $showHelp) {
        } content: {
            HelpView()
                .frame(maxWidth: 500)
        }
    }
    
}

#Preview {
    ImageGridView(listId: .left)
}

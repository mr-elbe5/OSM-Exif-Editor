/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MainView: View {
    
    @State var mainStatus: MainStatus = MainStatus.shared
    
    var body: some View {
        HStack{
            VStack{
                MainMenu()
                    .zIndex(1)
                
                ImageGridView()
                    .frame(maxWidth: .infinity)
                    .zIndex(1)
            }
            VStack{
                ExifEditView()
                    .zIndex(1)
                MapContainerView()
            }
            .frame(width: 400)
        }
        
    }
    
}
    
#Preview {
    MainView()
}

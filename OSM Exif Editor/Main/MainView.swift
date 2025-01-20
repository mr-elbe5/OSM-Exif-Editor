/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MainView: View {
    
    @State var mainStatus: MainStatus = MainStatus.shared
    
    var body: some View {
        GeometryReader { proxy in
            VStack{
                MainMenu()
                    .zIndex(1)
                HStack{
                    ImageGridView()
                        .frame(maxWidth: .infinity)
                        .zIndex(1)
                    VStack{
                        ExifEditView()
                            .zIndex(1)
                        MapContainerView()
                    }
                    .frame(width: 300)
                }
            }
            
        }
    }
    
}
    
#Preview {
    MainView()
}

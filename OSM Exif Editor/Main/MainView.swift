/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MainView: View {
    
    @State var preferences = Preferences.shared
    @State var appData = ApplicationData.shared
    @State var mainStatus: CurrentImage = CurrentImage.shared
    
    var body: some View {
        HStack{
            VStack(spacing: 0){
                MainMenu()
                    .zIndex(1)
                Color.gray
                    .frame(height: 1)
                if preferences.showTwoColumns {
                    GeometryReader{ geometry in
                        HStack{
                            ImageGridView(listId: .left)
                                .frame(width: geometry.size.width/2)
                                .zIndex(1)
                            Color.gray
                                .frame(width: 1)
                            ImageGridView(listId: .right)
                                .frame(width: geometry.size.width/2)
                                .zIndex(1)
                        }
                    }
                }
                else{
                    ImageGridView(listId: .left)
                        .frame(maxWidth: .infinity)
                        .zIndex(1)
                }
            }
            VStack(){
                ExifEditView()
                    .zIndex(1)
                MapContainerView()
                    .padding()
            }
            .frame(width: 400)
        }
        
    }
    
}
    
#Preview {
    MainView()
}

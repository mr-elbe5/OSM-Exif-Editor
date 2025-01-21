/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MainMenu: View {

    @State var appData: ApplicationData = ApplicationData.shared
    @State var showImporter: Bool = false
    @State var showPreferences: Bool = false
    
    var body: some View {
        HStack() {
            Button(action: {
                showImporter = true
            }, label: {HStack{
                Image(systemName: "photo.on.rectangle")
                Text("selectImages".localize())}
            }
            )
            .padding()
            Spacer()
            Button(action: {
                showPreferences = true
            }, label: {HStack{
                Image(systemName: "gearshape")
                Text("preferences".localize())}
            })
            .padding()
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.jpeg, .png, .tiff], allowsMultipleSelection: true, onCompletion: { result in
            switch result {
            case .success(let urls):
                appData.imageList.removeAll()
                urls.forEach { url in
                    if let data = url.getSecureData() {
                        let imageData = ImageData(url: url, data: data)
                        appData.imageList.append(imageData)
                    }

                }
                CurrentImage.shared.reset()
            case .failure(let error):
                debugPrint(error)
            }
        })
        .sheet(isPresented: $showPreferences) {
        } content: {
            PreferencesView()
                .frame(maxWidth: 300)
        }
    }
    
}

#Preview {
    ImageGridView()
}

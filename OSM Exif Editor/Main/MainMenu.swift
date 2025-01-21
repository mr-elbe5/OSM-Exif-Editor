/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct MainMenu: View {

    @State var appData: ApplicationData = ApplicationData.shared
    @State var showImporter: Bool = false
    
    
    var body: some View {
        HStack() {
            Button(action: {
                showImporter = true
            }, label: {Text("selectImages".localize())}
            )
            .padding()
            Spacer()
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
                MainStatus.shared.reset()
            case .failure(let error):
                debugPrint(error)
            }
        })
    }
    
}

#Preview {
    ImageGridView()
}

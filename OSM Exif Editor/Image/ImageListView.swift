/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct ImageListView: View {

    @State var imageItems: ImageItemList = ApplicationData.shared.imageList
    @State var showImporter: Bool = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            Text("imageSelection".localize())
                .font(.headline)
                .padding(10)
            Button(action: {
                showImporter = true
            }, label: {Text("selectImages".localize())}
            )
            .padding(5)
            List {
                ForEach(imageItems, id: \.id) { item in
                    ImageCellView(imageData: item)
                }
            }
            .padding()
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.image], allowsMultipleSelection: true, onCompletion: { result in
            switch result {
            case .success(let urls):
                urls.forEach { url in
                    let gotAccess = url.startAccessingSecurityScopedResource()
                    if gotAccess, let data = FileManager.default.readFile(url: url){
                        let imageItem = ImageData(url: url, data: data)
                        imageItems.append(imageItem)
                        url.stopAccessingSecurityScopedResource()
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
    ImageListView()
}

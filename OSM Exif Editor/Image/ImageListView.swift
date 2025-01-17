/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI
import PhotosUI
import Photos

struct ImageListView: View {
    
    @State var imageItems: ImageItemList = ApplicationData.shared.imageList
    @State var showImporter: Bool = false
    
    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack {
            Button(action: {
                showImporter = true
            }, label: {Text("Select Images from File System")}
            )
            .padding()
            PhotosPicker(selection: $selectedItems, matching: .images, photoLibrary: .shared()) {
                Text("Select Images from Photo Library")
            }
            .onChange(of: selectedItems, initial: false){
                Task {
                    var list = ImageItemList()
                    for item in selectedItems {
                        guard let data = try? await item.loadTransferable(type: Data.self) else { continue }
                        debugPrint(item.itemIdentifier ?? "no ident")
                        let imageData = PHImageData(localIdentifier: item.itemIdentifier ?? "", data: data)
                        list.append(imageData)
                    }
                    imageItems.removeAll()
                    imageItems.append(contentsOf: list)
                }
            }
            List {
                ForEach(imageItems, id: \.id) { item in
                    ImageCellView(imageItem: item)
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
                        let imageItem = FileImageData(url: url, data: data)
                        imageItems.append(imageItem)
                        url.stopAccessingSecurityScopedResource()
                    }
                    
                }
            case .failure(let error):
                debugPrint(error)
            }
            
        })
    }
    
    func selectImages(){
        
    }
    
}

#Preview {
    ImageListView()
}

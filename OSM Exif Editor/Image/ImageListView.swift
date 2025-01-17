/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI
import PhotosUI

struct ImageListView: View {
    
    @State var imageItems: ImageItemList = ApplicationData.shared.imageList
    @State var showImporter: Bool = false
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var phImages: [PHImageData] = []
    @State private var loading: Bool = false
    
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
            .onChange(of: selectedItems, loadImages)
            List {
                ForEach(imageItems, id: \.id) { item in
                    ImageCellView(imageItem: item)
                }
            }
            .padding()
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.image], allowsMultipleSelection: true, onCompletion: { result in
            switch result {
            case .success(let files):
                files.forEach { file in
                    let gotAccess = file.startAccessingSecurityScopedResource()
                    if !gotAccess { return }
                    debugPrint(file.path)
                    file.stopAccessingSecurityScopedResource()
                }
            case .failure(let error):
                debugPrint(error)
            }
            
        })
    }
    
    func selectImages(){
        
    }
    
    func loadImages() {
        loading = true
        Task {
            debugPrint("starting task with \(selectedItems.count) selected items")
            var phImages: [PHImageData] = []
            var identifiers: [String] = []
            for item in self.selectedItems{
                if let identifier = item.itemIdentifier {
                    identifiers.append(identifier)
                }
            }
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let results = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: options)
            for i in 0..<results.count {
                let asset = results[i]
                if asset.mediaType == .image {
                    debugPrint("got image asset image for \(asset.localIdentifier)")
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .highQualityFormat
                    options.isNetworkAccessAllowed = true
                    if let imageData = try await PHImageManager.default().requestImage(for: asset, options: options){
                        let resources = PHAssetResource.assetResources(for: asset)
                        if let resource = resources.first {
                            imageData.fileName = resource.originalFilename
                            imageData.size = CGSize(width: resource.pixelWidth, height: resource.pixelHeight)
                        }
                        imageData.evaluateExifData()
                        if imageData.coordinate == nil {
                            imageData.coordinate = asset.location?.coordinate
                        }
                        debugPrint("got \(imageData.fileName) created on \(imageData.creationDate?.dateTimeString() ?? "unknown date") at location \(imageData.coordinate?.asShortString ?? "unknown")")
                        phImages.append(imageData)
                    }
                }
            }
            DispatchQueue.main.async {
                //debugPrint("replacing phImages")
                self.phImages = phImages
                loading = false
            }
        }
    }
}

#Preview {
    ImageListView()
}

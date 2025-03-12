/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct ImageGridView: View {
    
    static let cellSize: CGFloat = 200

    @State var preferences = Preferences.shared
    @State var appData: ApplicationData = ApplicationData.shared
    @State var listId: ListId
    
    @State var showImporter: Bool = false
    
    var body: some View {
        
        let columns = [
            GridItem(.adaptive(minimum: ImageGridView.cellSize))
            ]
        
        VStack{
            HStack{
                Button(action: {
                    showImporter = true
                }, label: {
                    HStack{
                    Image(systemName: "photo.on.rectangle")
                    Text("selectImages".localize())}
                }
                )
                .padding()
                Button(action: {
                    appData.sortByDate(id: listId)
                }, label:{
                    HStack{
                        Image(systemName: "arrow.down")
                        Text("sortByDate".localize())
                    }
                })
                Button(action: {
                    appData.sortByLatitude(id: listId)
                }, label:{
                    HStack{
                        Image(systemName: "arrow.down")
                        Text("sortByLatitude".localize())
                    }
                })
                .padding()
                Button(action: {
                    appData.sortByLongitude(id: listId)
                }, label:{
                    HStack{
                        Image(systemName: "arrow.down")
                        Text("sortByLongitude".localize())
                    }
                })
                .padding()
                Spacer()
            }
            ScrollView(){
                LazyVGrid(columns: columns){
                    ForEach(imageList, id: \.id) { item in
                        ImageCellView(imageData: item)
                        .frame(width: ImageGridView.cellSize, height: ImageGridView.cellSize)
                    }
                }
                .padding(.all)
            }
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.jpeg, .png, .tiff], allowsMultipleSelection: true, onCompletion: { result in
            switch result {
            case .success(let urls):
                appData.removeAllImages(of: listId)
                urls.forEach { url in
                    if let data = url.getSecureData() {
                        let imageData = ImageData(url: url, data: data)
                        appData.addImage(imageData, to: listId)
                    }

                }
                CurrentImage.shared.reset()
            case .failure(let error):
                debugPrint(error)
            }
        })
    }
    
    var imageList: ImageDataList {
        switch listId {
        case .left:
            return appData.leftImageList
        case .right:
            return appData.rightImageList
        @unknown default:
            fatalError("Unknown listId")
        }
    }
    
}

#Preview {
    ImageGridView(listId: .left)
}

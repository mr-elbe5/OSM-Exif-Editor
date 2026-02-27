/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation
import UniformTypeIdentifiers

class AppData : NSObject, Codable{
    
    static var storeKey = "appData"
    
    static var imageExtensions = ["jpg", "jpeg", "heif", "png", "gif", "dng"]
    
    static var shared = AppData()
    
    static func loadData(){
        if let data: AppData = StatusManager.shared.getCodable(key: storeKey){
            shared = data
        }
        else{
            shared = AppData()
        }
    }
    
    func save(){
        if StatusManager.shared.saveCodable(key: Self.storeKey, value: self){
            
        }
        else{
            Log.error("could not save app data to StatusManager")
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case bookmark
    }
    
    var bookmark: Data? = nil
    var folderURL: URL? = nil
    var images = ImageList()
    var sortType: ImageSortType = .byFileCreation
    var ascending = true
    
    var name: String{
        folderURL?.lastPathComponent ?? ""
    }
    
    var selectedImages: ImageList{
        get{
            var images = ImageList()
            for image in self.images{
                if image.selected{
                    images.append(image)
                }
            }
            images.sort(by: sortType, ascending: ascending)
            return images
        }
    }
    
    override init(){
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        bookmark = try values.decodeIfPresent(Data.self, forKey: .bookmark)
        super.init()
        if setFolderURL(), let url = folderURL{
            Log.info("folder url is \(url.path())")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bookmark, forKey: .bookmark)
    }
    
    func setFolderURL() -> Bool{
        if let bookmark = bookmark{
            var stale: Bool = false
            let bookmarkURL = try? URL(resolvingBookmarkData: bookmark, options: [.withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &stale)
            if bookmarkURL != nil, stale == false, FileManager.default.isDirectory(url: bookmarkURL!){
                return setFolderUrl(bookmarkURL!)
            }
        }
        return false
    }
    
    func setFolderUrl(_ url:URL) -> Bool{
        folderURL = url
        if startSecurityScope(){
            let result = scan()
            stopSecurityScope()
            return result
        }
        return false
    }
    
    func setBookmark(){
        do{
            bookmark = try folderURL?.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
        }
        catch{
            bookmark = nil
        }
    }
    
    func startSecurityScope() -> Bool{
        folderURL?.startAccessingSecurityScopedResource() ?? false
    }
    
    func stopSecurityScope(){
        folderURL?.stopAccessingSecurityScopedResource()
    }
    
    func scan() -> Bool{
        if let url = folderURL, startSecurityScope(){
            images.removeAll()
            var childURLs = Array<URL>()
            do{
                childURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: .skipsHiddenFiles)
            }
            catch{
                return false
            }
            for childURL in childURLs{
                if let utType = childURL.utType{
                    let isImage = utType.isSubtype(of: .image) || utType.isSubtype(of: .rawImage)
                    //Log.info("uttype of \(childURL) is image: \(isImage)")
                    do{
                        if isImage{
                            let resourceValues = try childURL.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey, .fileSizeKey, .isRegularFileKey])
                            if !(resourceValues.isRegularFile ?? false), !Self.imageExtensions.contains(childURL.pathExtension.lowercased()){
                                continue
                            }
                            let image = ImageData(url: childURL)
                            image.size = resourceValues.fileSize ?? -1
                            image.fileCreationDate = resourceValues.creationDate
                            image.fileModificationDate = resourceValues.contentModificationDate
                            images.append(image)
                        }
                    }
                    catch (let err){
                        Log.error(err.localizedDescription)
                    }
                }
            }
            sortImages()
            return true
        }
        return false
    }
    
    func sortImages(){
        images.sort(by: sortType, ascending: ascending)
    }
    
}

extension AppData: NSCollectionViewDataSource{
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let image = images[indexPath.item]
        if image.selected{
            collectionView.selectionIndexPaths.insert(indexPath)
        }
        let item = ImageGridViewItem(image: image)
        item.isSelected = image.selected
        item.setHighlightState()
        return item
    }
    
}

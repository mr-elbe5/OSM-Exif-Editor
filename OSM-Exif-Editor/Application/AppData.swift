/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

class AppData : Codable{
    
    static var storeKey = "appData"
    
    static var shared = AppData()
    
    static func load(){
        if let data: AppData = StatusManager.shared.getCodable(key: storeKey){
            Log.debug("got \(data.images.count) local images")
            Log.debug("got \(data.tracks.count) local tracks")
            shared = data
        }
        else{
            shared = AppData()
        }
    }
    
    func save(){
        if StatusManager.shared.saveCodable(key: Self.storeKey, value: self){
            Log.debug("saved \(images.count) local images")
            Log.debug("saved \(tracks.count) local tracks")
        }
        else{
            Log.error("could not save map items data to StatusManager")
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case mapItems
    }
    
    private var _mapItems: MapItemList
    
    var mapItems: MapItemList{
        get{
            return _mapItems
        }
    }
    
    var images: ImageItemList{
        get{
            var imageItems = ImageItemList()
            for item in _mapItems{
                if item is ImageItem{
                    imageItems.append(item as! ImageItem)
                }
            }
            imageItems.sortByDate(ascending: ViewFilter.shared.defaultSortAscending)
            return imageItems
        }
    }
    
    var selectedImages: ImageItemList{
        get{
            var imageItems = ImageItemList()
            for item in _mapItems{
                if item is ImageItem, item.selected{
                    imageItems.append(item as! ImageItem)
                }
            }
            imageItems.sortByDate(ascending: ViewFilter.shared.defaultSortAscending)
            return imageItems
        }
    }
    
    var tracks: TrackItemList{
        get{
            var trackItems = TrackItemList()
            for item in _mapItems{
                if item is TrackItem{
                    trackItems.append(item as! TrackItem)
                }
            }
            trackItems.sortByDate(ascending: ViewFilter.shared.defaultSortAscending)
            return trackItems
        }
    }
    
    init(){
        _mapItems = MapItemList()
    }
    
    required init(from decoder: Decoder) throws {
        let values: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        let mapItemsMetaData = try values.decodeIfPresent(MapItemMetaDataList.self, forKey: .mapItems) ?? MapItemMetaDataList()
        _mapItems = mapItemsMetaData.items
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let mapItemsMetaData = MapItemMetaDataList(items: _mapItems)
        try container.encode(mapItemsMetaData, forKey: .mapItems)
    }
    
    func saveAsFile() -> URL?{
        let value = self.toJSON()
        let url = URL.temporaryDirectory.appendingPathComponent(Self.storeKey + ".json")
        if FileManager.default.saveFile(text: value, url: url){
            return url
        }
        return nil
    }
    
    func loadFromFile(url: URL){
        if let string = FileManager.default.readTextFile(url: url),let data : AppData = AppData.fromJSON(encoded: string){
            _mapItems.removeAll()
            _mapItems.append(contentsOf: data._mapItems)
        }
    }
    
    func addItem(_ item: MapItem){
        _mapItems.append(item)
    }
    
    func getItem(at coordinate: CLLocationCoordinate2D) -> MapItem?{
        for item in _mapItems{
            if item.coordinate == coordinate || item.coordinate.distance(to: coordinate) < MapItem.mergeDistance{
                return item
            }
        }
        return nil
    }
    
    func deleteAllData(){
        _mapItems.removeAll()
        FileManager.default.deleteAllFiles(dirURL: BasePaths.imageDirURL)
        FileManager.default.deleteAllFiles(dirURL: BasePaths.previewDirURL)
        save()
    }
    
    func deleteItem(_ item: MapItem){
        item.prepareToDelete()
        _mapItems.remove(obj: item)
    }
    
    func deleteItems(_ items: MapItemList){
        for item in items{
            item.prepareToDelete()
            _mapItems.remove(obj: item)
        }
    }
    
    func deleteItem(withId id: UUID){
        for item in _mapItems{
            if item.id == id{
                item.prepareToDelete()
                _mapItems.remove(obj: item)
                return
            }
        }
    }
    
    func sortItemsByDate(ascending: Bool){
        if ascending{
            _mapItems.sort(by: { $0.creationDate < $1.creationDate})
        }
        else{
            _mapItems.sort(by: { $0.creationDate > $1.creationDate})
        }
    }
    
    func getImagesOfTrack(item: TrackItem, maxDistance: Double = 20) -> ImageItemList{
        var list = ImageItemList()
        let track = item.track
        for mapItem in mapItems{
            if let image = mapItem as? ImageItem, mapItem.hasValidCoordinate{
                if let result = track.trackpoints.findNearestPoint(to: image.coordinate){
                    let distance = result.1
                    if distance < maxDistance{
                        list.append(image)
                    }
                }
            }
        }
        return list
    }
    
    func getImagesOfTrackTime(item: TrackItem) -> ImageItemList{
        var list = ImageItemList()
        let startDate = item.track.startTime
        let endDate = item.track.endTime
        for item in mapItems{
            if let image = item as? ImageItem{
                if image.creationDate >= startDate && image.creationDate <= endDate{
                    list.append(image)
                }
            }
        }
        return list
    }
    
}

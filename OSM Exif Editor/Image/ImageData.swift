/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import AppKit
import Photos

@Observable class ImageData : Equatable, Hashable{
    
    static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        lhs.id == rhs.id
    }
    
    static let fileExtensions = ["jpg","jpeg","png","tiff","tif"]
    
    static var previewSize: CGFloat = 512
    
    var id : UUID = UUID()
    var url : URL
    var preview: NSImage? = nil
    var metaData = ImageMetaData()
    var loaded: Bool = false
    
    var creationDate: Date? {
        metaData.dateTime
    }
    
    var coordinate: CLLocationCoordinate2D? {
        metaData.coordinate
    }
    
    init(url: URL){
        id = UUID()
        self.url = url
        
    }
    
    func asssertComplete(){
        if !loaded{
            debugPrint("loading \(url.lastPathComponent)")
            if let data = url.getSecureData(){
                if let preview = NSImage.createResizedImage(of: NSImage(data: data), size: ImageData.previewSize){
                    self.preview = preview
                }
                else{
                    self.preview = NSImage(named: "gear.grey")!
                }
                metaData.readData(data: data)
            }
            loaded = true
        }
    }
    
    func getPreview() -> NSImage{
        asssertComplete()
        return preview!
    }
    
    func getData() -> Data?{
        url.getSecureData()
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
}

typealias ImageDataList = Array<ImageData>

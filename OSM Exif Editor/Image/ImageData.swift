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
    
    static var previewSize: CGFloat = 512
    
    var id : UUID = UUID()
    var data: Data
    var url : URL
    var preview: NSImage? = nil
    var metaData = ImageMetaData()
    
    var creationDate: Date? {
        metaData.dateTime
    }
    
    var coordinate: CLLocationCoordinate2D? {
        metaData.coordinate
    }
    
    init(url: URL, data: Data){
        id = UUID()
        self.data = data
        self.url = url
        evaluateExifData()
        createPreview()
    }
    
    func evaluateExifData(){
        metaData.readData(data: data)
    }
    
    func getImage() -> NSImage?{
        return NSImage(data: data)
    }
    
    func getPreview() -> NSImage?{
        if preview != nil{
            createPreview()
        }
        if let preview = preview{
            return preview
        } else{
            return nil
        }
    }
    
    func createPreview(){
        if let preview = NSImage.createResizedImage(of: getImage(), size: ImageData.previewSize){
            self.preview = preview
        }
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
}

typealias ImageItemList = Array<ImageData>

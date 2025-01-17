/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import AppKit

@Observable class ImageData : Equatable, Hashable{
    
    static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        lhs.id == rhs.id
    }
    
    static var previewSize: CGFloat = 512
    
    var id : UUID = UUID()
    var fileName: String = ""
    var utType: String? = nil
    var orientation: CGImagePropertyOrientation = .up
    var data: Data
    var preview: NSImage? = nil
    var selected = false
    var size: CGSize = .zero
    var coordinate: CLLocationCoordinate2D?
    var metaData = ImageMetaData()
    
    var creationDate: Date? {
        metaData.dateTime
    }
    
    init(data: Data){
        id = UUID()
        self.data = data
        evaluateExifData()
        createPreview()
    }
    
    func evaluateExifData(){
        metaData.readData(data: data)
        if let latitude = metaData.latitude, let longitude = metaData.longitude {
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
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

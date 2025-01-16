/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

@Observable class ImageItem : Equatable, Hashable{
    
    static func == (lhs: ImageItem, rhs: ImageItem) -> Bool {
        lhs.id == rhs.id
    }
    
    static var previewSize: CGFloat = 512
    
    var id : UUID = UUID()
    var placeName: String? = nil
    var fileURL : URL
    var selected = false
    var metaData: ImageMetaData? = nil
    var preview: OSImage? = nil
    
    init(url: URL){
        id = UUID()
        self.fileURL = url
        placeName = ""
    }
    
    func readMetaData(){
        if let data = FileManager.default.readFile(url: fileURL){
            metaData = ImageMetaData()
            metaData?.readData(data: data)
        }
    }
    
    func getImage() -> OSImage?{
        if let data = FileManager.default.readFile(url: fileURL){
            return OSImage(data: data)
        } else{
            return nil
        }
    }
    
    func getPreview() -> OSImage?{
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
        if let preview = OSImage.createResizedImage(of: getImage(), size: ImageItem.previewSize){
            self.preview = preview
        }
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
}

typealias ImageItemList = Array<ImageItem>

import Foundation
import CoreLocation
import AppKit

@Observable class FileImageData : ImageData{
    
    var url : URL
    
    init(url: URL, data: Data){
        self.url = url
        super.init(data: data)
        fileName = url.lastPathComponent
    }
    
}

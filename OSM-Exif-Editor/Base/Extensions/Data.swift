/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import ImageIO
import UniformTypeIdentifiers

extension Data{
    
    func getExifData() -> NSDictionary? {
        var exifData: CFDictionary? = nil
        self.withUnsafeBytes {
            let bytes = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
            if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, self.count), let source = CGImageSourceCreateWithData(cfData, nil) {
                exifData = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
            }
        }
        return exifData as NSDictionary?
    }
    
}

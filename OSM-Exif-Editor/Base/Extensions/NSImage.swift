/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UniformTypeIdentifiers
import AppKit

extension NSImage{
    convenience init?(iconName: String){
        self.init(systemSymbolName: iconName, accessibilityDescription: nil)
    }
    
    convenience init(cgImage: CGImage){
        self.init(cgImage: cgImage, size: .zero)
    }
    
    static func getJpegData(from image: NSImage?) -> Data?{
        guard let image else { return nil }
        if let tiff = image.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .jpeg, properties: [:])
        }
        return nil
    }
    
    func withTintColor(_ col: NSColor) -> NSImage{
        let config = NSImage.SymbolConfiguration(paletteColors: [col])
        return self.withSymbolConfiguration(config)!
    }
    
    var pixelSize: NSSize {
        guard representations.count > 0 else { return NSSize(width: 1, height: 1) }
        let rep = self.representations[0]
        return NSSize(width: rep.pixelsWide, height: rep.pixelsHigh)
    }
}

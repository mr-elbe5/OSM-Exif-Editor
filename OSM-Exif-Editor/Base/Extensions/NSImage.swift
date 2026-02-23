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
    
    static func createResizedImage(of img: NSImage?, size: CGFloat) -> NSImage?{
        if let img = img{
            if (img.size.width<=size) && (img.size.height<=size) {
                return img
            }
            let widthRatio = size/img.size.width
            let heightRatio = size/img.size.height
            let ratio = min(widthRatio,heightRatio)
            let newWidth = floor(img.size.width * ratio)
            let newHeight = floor(img.size.height * ratio)
            let rect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
            guard let representation = img.bestRepresentation(for: rect, context: nil, hints: nil) else {
                return nil
            }
            let image = NSImage(size: CGSize(width: newWidth, height: newHeight), flipped: false, drawingHandler: { (_) -> Bool in
                representation.draw(in: rect)
            })
            return image
        }
        return nil
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
        guard representations.count > 0 else { return NSSize(width: 0, height: 0) }
        let rep = self.representations[0]
        return NSSize(width: rep.pixelsWide, height: rep.pixelsHigh)
    }
}

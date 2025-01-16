/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

class PreviewCreator{
    
#if os(macOS)
    static func createPreview(of img: NSImage?, size: CGFloat = 512) -> NSImage?{
        if let img = img{
            if (img.size.width<=MapDefaults.previewSize) && (img.size.height<=MapDefaults.previewSize) {
                return img
            }
            let widthRatio = MapDefaults.previewSize/img.size.width
            let heightRatio = MapDefaults.previewSize/img.size.height
            let ratio = min(widthRatio,heightRatio)
            let newWidth = floor(img.size.width * ratio)
            let newHeight = floor(img.size.height * ratio)
            let frame = NSRect(x: 0, y: 0, width: newWidth, height: newHeight)
            guard let representation = img.bestRepresentation(for: frame, context: nil, hints: nil) else {
                return nil
            }
            let image = NSImage(size: CGSize(width: newWidth, height: newHeight), flipped: false, drawingHandler: { (_) -> Bool in
                representation.draw(in: frame)
            })
            return image
        }
        return nil
    }
#elseif os(iOS)
    static func createPreview(of img: UIImage?, size: CGFloat = 512) -> UIImage?{
        if let img = img{
            if (img.size.width<=MapDefaults.previewSize) && (img.size.height<=MapDefaults.previewSize) {
                return img
            }
            let widthRatio = size/img.size.width
            let heightRatio = size/img.size.height
            let ratio = min(widthRatio,heightRatio)
            let newSize = CGSize(width: img.size.width*ratio, height: img.size.height*ratio)
            let renderer = UIGraphicsImageRenderer(size: newSize)
            return renderer.image{ (context) in
                return img.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
        return nil
    }
#endif
    
}

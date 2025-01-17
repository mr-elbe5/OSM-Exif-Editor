/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import SwiftUI
import AppKit

extension NSImage{
    
    static func createResizedImage(of img: NSImage?, size: CGFloat = 512) -> NSImage?{
        if let img = img{
            if (img.size.width<=size) && (img.size.height<=size) {
                return img
            }
            let widthRatio = size/img.size.width
            let heightRatio = size/img.size.height
            let ratio = min(widthRatio,heightRatio)
            let newWidth = floor(img.size.width * ratio)
            let newHeight = floor(img.size.height * ratio)
            let frame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
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
    
    static func getJpegData(from image: NSImage?) -> Data?{
        guard let image else { return nil }
        if let tiff = image.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .jpeg, properties: [:])
        }
        return nil
    }
    
}


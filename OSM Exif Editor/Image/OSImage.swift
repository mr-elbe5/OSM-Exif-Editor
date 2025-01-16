/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import SwiftUI

#if os(macOS)
import AppKit
#else
import UIKit
#endif

#if os(macOS)
typealias OSImage = NSImage
#else
typealias OSImage = UIImage
#endif

extension Image{
#if os(macOS)
    init (osImage: OSImage){
        self.init(nsImage: osImage)
    }
#else
    init (osImage: OSImage){
        self.init(uiImage: osImage)
    }
#endif
}

#if os(iOS) || os(macOS)
extension OSImage{
    
    static func createResizedImage(of img: OSImage?, size: CGFloat = 512) -> OSImage?{
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
#if os(macOS)
            guard let representation = img.bestRepresentation(for: frame, context: nil, hints: nil) else {
                return nil
            }
            let image = NSImage(size: CGSize(width: newWidth, height: newHeight), flipped: false, drawingHandler: { (_) -> Bool in
                representation.draw(in: frame)
            })
#elseif os(iOS)
            let renderer = UIGraphicsImageRenderer(size: frame.size)
            let image = renderer.image{ (context) in
                return img.draw(in: CGRect(origin: .zero, size: frame.size))
            }
#endif
            return image
        }
        return nil
    }
}
#endif
  
extension OSImage{
    
    static func getJpegData(from image: OSImage?) -> Data?{
        guard let image else { return nil }
#if os(macOS)
        if let tiff = image.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .jpeg, properties: [:])
        }
        return nil
#else
        return  image.jpegData(compressionQuality: 0.85)
#endif
    }
}


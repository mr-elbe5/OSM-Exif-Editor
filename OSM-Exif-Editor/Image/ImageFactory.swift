/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Foundation
import Cocoa
import UniformTypeIdentifiers

open class ImageFactory {

    static var instance : ImageFactory = ImageFactory()
    
    func createImageFile(original: NSImage, utType: UTType, targetURL: URL, maxSide: CGFloat) -> Bool {
        var source = original
        if maxSide > 0, let resized = createResizedImage(original: original, maxSide: maxSide){
            source = resized
        }
        if let tiff = source.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            if let previewData = tiffData.representation(using: utType.bitmapType, properties: [:]) {
                if FileManager.default.assertDirectoryFor(url: targetURL){
                    //print("saving preview at \(targetURL.lastPathComponent)")
                    return FileManager.default.saveFile(data: previewData, url: targetURL)
                }
            }
        }
        return false
    }
    
    func createResizedImage(original: NSImage, maxSide: CGFloat) -> NSImage? {
        var ratio: CGFloat
        let originalPixelSize = original.pixelSize
        if originalPixelSize.width > originalPixelSize.height{
            ratio = min(1.0,maxSide/originalPixelSize.width)
        }
        else{
            ratio = min(1.0,maxSide/originalPixelSize.height)
        }
        if ratio == 1.0{
            return original
        }
        let newWidth = floor(originalPixelSize.width * ratio)
        let newHeight = floor(originalPixelSize.height * ratio)
        let frame = NSRect(x: 0, y: 0, width: newWidth, height: newHeight)
        guard let representation = original.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        let image = NSImage(size: CGSize(width: newWidth, height: newHeight), flipped: false, drawingHandler: { (_) -> Bool in
            representation.draw(in: frame)
        })
        return image
    }

}

/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Foundation
import Cocoa
import UniformTypeIdentifiers

class ImageFactory {

    static var shared : ImageFactory = ImageFactory()
    
    func createResizedJpegData(original: NSImage, maxSide: CGFloat) -> Data?{
        if let image = createResizedImage(original: original, maxSide: maxSide), let tiff = image.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .jpeg, properties: [:])
        }
        return nil
    }
    
    func createResizedJpegFile(original: NSImage, maxSide: CGFloat, targetURL: URL) -> Bool{
        if let data = createResizedJpegData(original: original, maxSide: maxSide){
            if FileManager.default.assertDirectoryFor(url: targetURL){
                return FileManager.default.saveFile(data: data, url: targetURL)
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


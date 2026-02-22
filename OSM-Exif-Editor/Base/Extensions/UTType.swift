/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import UniformTypeIdentifiers

@available(macOS 11.0, iOS 14.0, *)
public extension UTType {
    
    static var exportTypes:Array<UTType> = [UTType.jpeg, UTType.png, UTType.tiff]
    static var exportTypeNames: Array<String> = [UTType.jpeg.identifier, UTType.png.identifier, UTType.tiff.identifier]
    
    var bitmapType: NSBitmapImageRep.FileType{
        switch self{
        case .png: return .png
        case .tiff: return .tiff
        default: return .jpeg
        }
    }
    
    static var gpx: UTType {
        let tags = UTType.types(tag: "gpx", tagClass: .filenameExtension, conformingTo: .xml)
        return tags.first(where: { $0.identifier.contains("topografix") }) ?? tags.first!
    }
    
}

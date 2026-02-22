/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation


class ImageDetailView: NSScrollView{
    
    var image: ImageItem? = nil
    
    var detailContentView = NSView()
    
    override func setupView() {
        asVerticalScrollView(contentView: detailContentView)
        updateView()
    }
    
    func updateView() {
        contentView.removeAllSubviews()
        if let image = image{
            var label = NSTextField(labelWithString: "\("name".localize()): \(image.fileName)")
            contentView.addSubviewBelow(label)
            var lastView = label
            if image.size >= 0{
                label = NSTextField(labelWithString: "\("fileSize".localize()): \(image.sizeString)")
                contentView.addSubviewBelow(label, upperView: lastView)
                lastView = label
            }
            if let exifData = image.exifData{
                label = NSTextField(labelWithString: "\("size".localize()): \(exifData.exifWidth)x\(exifData.exifHeight)")
                contentView.addSubviewBelow(label, upperView: lastView)
                lastView = label
                if !exifData.exifLensModel.isEmpty{
                    label = NSTextField(labelWithString: "\("camera".localize()): \(exifData.exifLensModel)")
                    contentView.addSubviewBelow(label, upperView: lastView)
                    lastView = label
                }
                if let date = exifData.exifCreationDate{
                    label = NSTextField(labelWithString: "\("creationDate".localize()): \(date.dateTimeString())")
                    contentView.addSubviewBelow(label, upperView: lastView)
                    lastView = label
                }
                if let latitude = exifData.exifLatitude, let longitude = exifData.exifLongitude{
                    label = NSTextField(labelWithString: "\("latitude".localize()): \(String(format: "%.5f", latitude))")
                    contentView.addSubviewBelow(label, upperView: lastView)
                    lastView = label
                    label = NSTextField(labelWithString: "\("longitude".localize()): \(String(format: "%.5f", longitude))")
                    contentView.addSubviewBelow(label, upperView: lastView)
                    lastView = label
                }
                if let altitude = exifData.exifAltitude{
                    label = NSTextField(labelWithString: "\("altitude".localize()): \(Int(altitude))")
                    contentView.addSubviewBelow(label, upperView: lastView)
                    lastView = label
                }
            }
            lastView.connectToBottom(of: contentView)
        }
    }
    
    func setImage(_ image: ImageItem?){
        self.image = image
        updateView()
    }
    
}



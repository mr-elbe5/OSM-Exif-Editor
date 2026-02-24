/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Cocoa

class ImageExifView: NSView {
    
    private var image: ImageItem?{
        AppData.shared.detailImage
    }
    
    var header = NSTextField(labelWithString: "imageDetails".localize())
    
    let nameView = NSTextField(wrappingLabelWithString: " ")
    let lensModelView = NSTextField(wrappingLabelWithString: " ")
    let widthView = NSTextField(wrappingLabelWithString: " ")
    let heightView = NSTextField(wrappingLabelWithString: " ")
    let latitudeView = NSTextField(wrappingLabelWithString: " ")
    let longitudeView = NSTextField(wrappingLabelWithString: " ")
    let altitudeView = NSTextField(wrappingLabelWithString: " ")
    let exifCreationDateView = NSTextField(wrappingLabelWithString: " ")
    let fileCreationDateView = NSTextField(wrappingLabelWithString: " ")
    let fileModificationDateView = NSTextField(wrappingLabelWithString: " ")
    
    let insets = NSEdgeInsets.zero
    
    override func setupView() {
        header.font = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)
        addSubviewCenteredBelow(header, insets: .defaultInsets)
        var lastView: NSView? = header
        lastView = addLabeledView(name: "name", view: nameView, upperView: lastView, insets: insets)
        lastView = addLabeledView(name: "lens", view: lensModelView, upperView: lastView, insets: insets)
        lastView = addLabeledView(name: "width".localize(), view: widthView, upperView: lastView, insets: insets)
        lastView = addLabeledView(name: "height".localize(), view: heightView, upperView: lastView, insets: insets)
        lastView = addLabeledView(name: "latitude".localize(), view: latitudeView, upperView: lastView, insets: insets)
        lastView = addLabeledView(name: "longitude".localize(), view: longitudeView, upperView: lastView, insets: insets)
        lastView = addLabeledView(name: "altitude".localize(), view: altitudeView, upperView: lastView, insets: insets)
        lastView = addLabeledView(name: "creationDate".localize(), view: exifCreationDateView, upperView: lastView, insets: insets)
        lastView = addLabeledView(name: "fileCreationDate".localize(), view: fileCreationDateView, upperView: lastView, insets: insets)
        lastView = addLabeledView(name: "fileModificationDate".localize(), view: fileModificationDateView, upperView: lastView, insets: insets)
        lastView?.connectToBottom(of: self, inset: insets.bottom)
    }
    
    func update(){
        if let image = image{
            nameView.stringValue = image.url.lastPathComponent
            lensModelView.stringValue = image.exifCameraModel ?? ""
            widthView.stringValue = image.exifWidth?.formatted(.number) ?? ""
            heightView.stringValue = image.exifHeight?.formatted(.number) ?? ""
            latitudeView.stringValue = image.exifLatitude?.coordinateString ?? ""
            longitudeView.stringValue = image.exifLongitude?.coordinateString ?? ""
            altitudeView.stringValue = image.exifAltitude?.formatted(.number) ?? ""
            exifCreationDateView.stringValue = image.exifCreationDate?.dateTimeString() ?? ""
            fileCreationDateView.stringValue = image.fileCreationDate?.dateTimeString() ?? ""
            fileModificationDateView.stringValue = image.fileModificationDate?.dateTimeString() ?? ""
        }
        else{
            nameView.stringValue = ""
            lensModelView.stringValue = ""
            widthView.stringValue = ""
            heightView.stringValue = ""
            latitudeView.stringValue = ""
            longitudeView.stringValue = ""
            altitudeView.stringValue = ""
            exifCreationDateView.stringValue = ""
            fileCreationDateView.stringValue = ""
        }
    }
    
}



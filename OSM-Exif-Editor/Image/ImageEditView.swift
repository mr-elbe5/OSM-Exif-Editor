/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Cocoa
import CoreLocation

protocol ImageEditViewDelegate{
    func imageIsModified()
}

class ImageEditView: NSView {
    
    private var image: ImageItem? = nil
    
    var header = NSTextField(labelWithString: "editExifData".localize())
    
    let nameView = NSTextField(wrappingLabelWithString: " ")
    var exifDateView = NSDatePicker()
    var fileDateView = NSDatePicker()
    var latitudeField = NSTextField(string: " ")
    var longitudeField = NSTextField(string: " ")
    var altitudeField = NSTextField(string: " ")
    
    let insets = NSEdgeInsets.zero
    
    var delegate: ImageEditViewDelegate? = nil
    
    override func setupView() {
        header.font = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)
        addSubviewCenteredBelow(header, insets: .defaultInsets)
        var lastView: NSView? = header
        lastView = addLabeledView(name: "name", view: nameView, upperView: lastView, insets: insets)
        lastView = addHorizontalDivider(upperView: lastView, color: .lightGray)
        exifDateView.dateValue = image?.exifCreationDate ?? Date()
        lastView = addLabeledView(name: "exifCreationDate", view: exifDateView, upperView: lastView)
        fileDateView.dateValue = image?.fileCreationDate ?? Date()
        var button = NSButton(title: "copyFileCreation".localize(), target: self, action: #selector(copyFileCreation))
        lastView = addSubviewBelow(button, upperView: lastView)
        lastView = addLabeledView(name: "fileCreationDate", view: fileDateView, upperView: lastView)
        button = NSButton(title: "copyExifCreation".localize(), target: self, action: #selector(copyExifCreation))
        lastView = addSubviewBelow(button, upperView: lastView)
        button = NSButton(title: "setNow".localize(), target: self, action: #selector(setNow))
        lastView = addSubviewBelow(button, upperView: lastView)
        lastView = addHorizontalDivider(upperView: lastView, color: .lightGray)
        exifDateView.dateValue = image?.creationDate ?? Date()
        lastView = addLabeledView(name: "latitude", view: latitudeField, upperView: lastView)
        lastView = addLabeledView(name: "longitude", view: longitudeField, upperView: lastView)
        lastView = addLabeledView(name: "altitude", view: altitudeField, upperView: lastView)
        button = NSButton(title: "getAltitude".localize(), target: self, action: #selector(getAltitude))
        lastView = addSubviewBelow(button, upperView: lastView)
        button = NSButton(title: "apply".localize(), target: self, action: #selector(apply))
        lastView = addSubviewBelow(button, upperView: lastView)
        lastView?.connectToBottom(of: self, inset: insets.bottom)
        update()
    }
    
    func setImage(_ image: ImageItem? = nil){
        self.image = image
        update()
    }
    
    func update(){
        if let image = image{
            nameView.stringValue = image.url.lastPathComponent
            exifDateView.dateValue = image.creationDate
            latitudeField.stringValue = image.exifLatitude?.coordinateString ?? ""
            longitudeField.stringValue = image.exifLongitude?.coordinateString ?? ""
            altitudeField.stringValue = image.exifAltitude?.formatted(.number) ?? ""
        }
        else{
            nameView.stringValue = ""
            exifDateView.dateValue = Date()
            latitudeField.stringValue = ""
            longitudeField.stringValue = ""
            altitudeField.stringValue = ""
        }
    }
    
    @objc func copyFileCreation(){
        exifDateView.dateValue = fileDateView.dateValue
    }
    
    @objc func copyExifCreation(){
        fileDateView.dateValue = exifDateView.dateValue
    }
    
    @objc func setNow(){
        fileDateView.dateValue = Date.now
    }
    
    @objc func getAltitude(){
        if let image = image, image.coordinate != .zero{
            ElevationProvider.shared.getElevation(for: image.coordinate){ altitude in
                DispatchQueue.main.async{
                    self.altitudeField.stringValue = altitude.formatted(.number)
                }
            }
        }
    }
    
    @objc func apply(){
        if let image = image{
            image.exifCreationDate = exifDateView.dateValue
            image.exifLatitude = latitudeField.doubleValue
            image.exifLongitude = longitudeField.doubleValue
            image.exifAltitude = altitudeField.doubleValue
            image.saveModifiedFile()
            image.isModified = true
            delegate?.imageIsModified()
        }
    }
    
}



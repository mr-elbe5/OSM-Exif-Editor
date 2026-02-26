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
    
    private var image: ImageData?{
        AppData.shared.detailImage
    }
    
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
        exifDateView.dateValue = image?.exifCreationDate ?? .zero
        exifDateView.action = #selector(modified)
        lastView = addLabeledView(name: "exifCreationDate", view: exifDateView, upperView: lastView)
        fileDateView.dateValue = image?.fileCreationDate ?? .zero
        fileDateView.action = #selector(modified)
        var button = NSButton(title: "copyFileCreation".localize(), target: self, action: #selector(copyFileCreation))
        lastView = addSubviewBelow(button, upperView: lastView)
        lastView = addLabeledView(name: "fileCreationDate", view: fileDateView, upperView: lastView)
        button = NSButton(title: "copyExifCreation".localize(), target: self, action: #selector(copyExifCreation))
        lastView = addSubviewBelow(button, upperView: lastView)
        button = NSButton(title: "setNow".localize(), target: self, action: #selector(setNow))
        lastView = addSubviewBelow(button, upperView: lastView)
        lastView = addHorizontalDivider(upperView: lastView, color: .lightGray)
        exifDateView.dateValue = image?.creationDate ?? .zero
        lastView = addLabeledView(name: "latitude", view: latitudeField, upperView: lastView)
        latitudeField.delegate = self
        lastView = addLabeledView(name: "longitude", view: longitudeField, upperView: lastView)
        longitudeField.delegate = self
        lastView = addLabeledView(name: "altitude", view: altitudeField, upperView: lastView)
        altitudeField.delegate = self
        button = NSButton(title: "coordinateFromMap".localize(), target: self, action: #selector(coordinateFromMap))
        lastView = addSubviewBelow(button, upperView: lastView)
        button = NSButton(title: "getAltitude".localize(), target: self, action: #selector(getAltitude))
        lastView = addSubviewBelow(button, upperView: lastView)
        lastView?.connectToBottom(of: self, inset: insets.bottom)
        update()
    }
    
    func update(){
        if let image = image{
            nameView.stringValue = image.url.lastPathComponent
            exifDateView.dateValue = image.exifCreationDate ?? .zero
            latitudeField.stringValue = image.exifLatitude?.coordinateString ?? ""
            longitudeField.stringValue = image.exifLongitude?.coordinateString ?? ""
            altitudeField.stringValue = image.exifAltitude?.formatted(.number) ?? ""
        }
        else{
            nameView.stringValue = ""
            exifDateView.dateValue = .zero
            latitudeField.stringValue = ""
            longitudeField.stringValue = ""
            altitudeField.stringValue = ""
        }
    }
    
    func setModified(){
        if let image = image, !image.isModified{
            image.isModified = true
            delegate?.imageIsModified()
        }
    }
    
    @objc func modified(sender: Any?){
        if let image = image, let sender = sender as? NSControl{
            Log.info("modified by \(sender)")
            switch sender{
            case exifDateView:
                image.exifCreationDate = exifDateView.dateValue == .zero ? nil : exifDateView.dateValue
            case fileDateView:
                image.fileCreationDate = fileDateView.dateValue == .zero ? nil : fileDateView.dateValue
            case latitudeField:
                image.exifLatitude = latitudeField.doubleValue
            case longitudeField:
                image.exifLongitude = longitudeField.doubleValue
            case altitudeField:
                image.exifAltitude = altitudeField.doubleValue
            default:
                break
            }
            setModified()
        }
    }
    
    @objc func copyFileCreation(){
        image?.exifCreationDate = fileDateView.dateValue == .zero ? nil : fileDateView.dateValue
        exifDateView.dateValue = fileDateView.dateValue
        setModified()
    }
    
    @objc func copyExifCreation(){
        image?.fileCreationDate = exifDateView.dateValue == .zero ? nil : exifDateView.dateValue
        fileDateView.dateValue = exifDateView.dateValue
        setModified()
    }
    
    @objc func setNow(){
        image?.fileCreationDate = Date.now
        fileDateView.dateValue = Date.now
        setModified()
    }
    
    @objc func coordinateFromMap(){
        let coordinate = MapStatus.shared.centerCoordinate
        image?.exifLatitude = coordinate.latitude
        image?.exifLongitude = coordinate.longitude
        latitudeField.stringValue = coordinate.latitude.coordinateString
        longitudeField.stringValue = coordinate.longitude.coordinateString
        setModified()
    }
    
    @objc func getAltitude(){
        if let image = image, let coordinate = image.coordinate{
            ElevationProvider.shared.getElevation(for: coordinate){ altitude in
                self.image?.exifAltitude = altitude
                DispatchQueue.main.async{
                    self.altitudeField.stringValue = altitude.formatted(.number)
                    self.setModified()
                }
            }
        }
    }
    
}

extension ImageEditView: NSTextFieldDelegate{
    
    func controlTextDidChange(_ obj: Notification){
        modified(sender: obj.object)
    }
    
}



/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Cocoa
import CoreLocation

class ImageEditViewController: ModalViewController {
    
    private var image: ImageItem?{
        AppData.shared.detailImage
    }
    
    var header = NSTextField(labelWithString: "editExifData".localize())
    
    let nameView = NSTextField(wrappingLabelWithString: " ")
    var dateView = NSDatePicker()
    var latitudeField = NSTextField(string: " ")
    var longitudeField = NSTextField(string: " ")
    var altitudeField = NSTextField(string: " ")
    
    let insets = NSEdgeInsets.zero
    
    override func loadView() {
        super.loadView()
        header.font = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)
        view.addSubviewCenteredBelow(header, insets: .defaultInsets)
        var lastView: NSView? = header
        lastView = view.addLabeledView(name: "name", view: nameView, upperView: lastView, insets: insets)
        lastView = view.addHorizontalDivider(upperView: lastView, color: .lightGray)
        dateView.dateValue = image?.creationDate ?? Date()
        lastView = view.addLabeledView(name: "creationDate", view: dateView, upperView: lastView)
        var button = NSButton(title: "setNow".localize(), target: self, action: #selector(setNow))
        lastView = view.addSubviewBelow(button, upperView: lastView)
        button = NSButton(title: "saveCreationDate".localize(), target: self, action: #selector(saveCreationDate))
        lastView = view.addSubviewBelow(button, upperView: lastView)
        lastView = view.addHorizontalDivider(upperView: lastView, color: .lightGray)
        dateView.dateValue = image?.creationDate ?? Date()
        lastView = view.addLabeledView(name: "latitude", view: latitudeField, upperView: lastView)
        lastView = view.addLabeledView(name: "longitude", view: longitudeField, upperView: lastView)
        lastView = view.addLabeledView(name: "altitude", view: altitudeField, upperView: lastView)
        button = NSButton(title: "copyMapLocation".localize(), target: self, action: #selector(copyMapLocation))
        lastView = view.addSubviewBelow(button, upperView: lastView)
        button = NSButton(title: "getAltitude".localize(), target: self, action: #selector(getAltitude))
        lastView = view.addSubviewBelow(button, upperView: lastView)
        button = NSButton(title: "saveLocation".localize(), target: self, action: #selector(saveLocation))
        lastView = view.addSubviewBelow(button, upperView: lastView)
        lastView?.connectToBottom(of: view, inset: insets.bottom)
        update()
    }
    
    func update(){
        if let image = image{
            nameView.stringValue = image.url.lastPathComponent
            dateView.dateValue = image.creationDate
            latitudeField.stringValue = image.exifLatitude?.coordinateString ?? ""
            longitudeField.stringValue = image.exifLongitude?.coordinateString ?? ""
            altitudeField.stringValue = image.exifAltitude?.formatted(.number) ?? ""
        }
        else{
            nameView.stringValue = ""
            dateView.dateValue = Date()
            latitudeField.stringValue = ""
            longitudeField.stringValue = ""
            altitudeField.stringValue = ""
        }
    }
    
    @objc func setNow(){
        dateView.dateValue = Date.now
    }
    
    @objc func saveCreationDate(){
        if let image = image{
            image.exifCreationDate = dateView.dateValue
            image.isModified = true
        }
    }
    
    @objc func copyMapLocation(){
        let coordinate = MapStatus.shared.centerCoordinate
        if let image = image, coordinate != .zero{
            image.exifLatitude = coordinate.latitude
            image.exifLongitude = coordinate.longitude
            self.latitudeField.stringValue = coordinate.latitude.coordinateString
            self.longitudeField.stringValue = coordinate.longitude.coordinateString
            image.isModified = true
        }
    }
    
    @objc func getAltitude(){
        if let image = image, image.coordinate != .zero{
            ElevationProvider.shared.getElevation(for: image.coordinate){ altitude in
                image.exifAltitude = altitude
                DispatchQueue.main.async{
                    self.altitudeField.stringValue = altitude.formatted(.number)
                }
            }
        }
    }
    
    @objc func saveLocation(){
        if let image = image{
            image.exifLatitude = latitudeField.doubleValue
            image.exifLongitude = longitudeField.doubleValue
            image.exifAltitude = altitudeField.doubleValue
            image.isModified = true
        }
    }
    
    @objc func saveChanges(){
        if let image = image{
            image.saveModifiedFile()
        }
    }
    
}



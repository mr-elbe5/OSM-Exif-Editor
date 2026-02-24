/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Cocoa
import CoreLocation

class ImageDetailView: NSView {
    
    enum ViewType {
        case exif
        case edit
    }
    
    var menuView = NSView()
    var editButton: NSButton!
    var modifiedLabel = NSTextField(labelWithString: "modified".localize())
    var scrollView = NSScrollView()
    var exifView = ImageExifView()
    
    override func setupView() {
        editButton = NSButton(text: "edit".localize(), target: self, action: #selector(openEditView))
        menuView.addSubviewToRight(editButton)
        menuView.addSubviewToLeft(modifiedLabel)
        addSubviewBelow(menuView, insets: .zero)
        let divider = NSView()
        divider.backgroundColor = .lightGray
        addSubviewBelow(divider, upperView: menuView, insets: .zero)
            .height(1)
        exifView.setupView()
        scrollView.asVerticalScrollView(contentView: exifView)
        addSubviewBelow(scrollView, upperView: divider, insets: .zero)
            .connectToBottom(of: self)
        updateView()
    }
    
    func updateView(){
        if let image = AppData.shared.detailImage{
            editButton.isEnabled = true
            modifiedLabel.isHidden = !image.isModified
        }
        else{
            editButton.isEnabled = false
            modifiedLabel.isHidden = true
        }
        exifView.update()
    }
    
    @objc func openEditView(){
        MainViewController.shared.openEditView()
    }
    
}





/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Cocoa
import CoreLocation

class ImageDetailView: NSView {
    
    private var image: ImageItem? = nil
    
    enum ViewType {
        case exif
        case edit
    }
    
    var menuView = NSView()
    var exifViewButton: NSButton!
    var editViewButton: NSButton!
    var containerView = NSView()
    var containerScrollView = NSScrollView()
    var exifView = ImageExifView()
    var editView = ImageEditView()
    
    override func setupView() {
        //backgroundColor = Statics.splitViewBackgroundColor
        exifViewButton = NSButton(icon: "text.page", target: self, action: #selector(openExifView))
        menuView.addSubviewToRight(exifViewButton)
        editViewButton = NSButton(icon: "long.text.page.and.pencil", target: self, action: #selector(openEditView))
        menuView.addSubviewToRight(editViewButton, leftView: exifViewButton)
        addSubviewBelow(menuView, insets: .zero)
        let divider = NSView()
        divider.backgroundColor = .lightGray
        addSubviewBelow(divider, upperView: menuView, insets: .zero)
            .height(1)
        containerScrollView.asVerticalScrollView(contentView: containerView)
        addSubviewBelow(containerScrollView, upperView: divider, insets: .zero)
            .connectToBottom(of: self)
        exifView.setupView()
        editView.setupView()
        setContainedView(.exif)
    }
    
    func setImage(_ image: ImageItem?){
        self.image = image
        update()
    }
    
    func setContainedView(_ type: ViewType){
        containerView.removeAllSubviews()
        switch(type){
        case .exif:
            containerView.addSubviewFilling(exifView, insets: .zero)
            exifView.setImage(image)
        case .edit:
            containerView.addSubviewFilling(editView, insets: .zero)
            editView.setImage(image)
        }
    }
    
    func update(){
        exifView.setImage(image)
        editView.setImage(image)
        //mapView.setImage(image)
    }
    
    @objc func openExifView(){
        setContainedView(.exif)
    }
    
    @objc func openEditView(){
        setContainedView(.edit)
    }
    
}





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
    var cancelButton: NSButton!
    var saveButton: NSButton!
    var containerView = NSView()
    var scrollView = NSScrollView()
    var exifView = ImageExifView()
    var editView = ImageEditView()
    var currentType: ViewType = .exif
    
    var image: ImageItem?{
        AppData.shared.detailImage
    }
    
    override func setupView() {
        editButton = NSButton(text: "edit".localize(), target: self, action: #selector(openEditView))
        cancelButton = NSButton(text: "cancel".localize(), target: self, action: #selector(cancelEditing))
        saveButton = NSButton(text: "save".localize(), target: self, action: #selector(saveImage))
        menuView.addSubviewToRight(editButton)
        menuView.addSubviewToRight(cancelButton)
        menuView.addSubviewToLeft(saveButton)
        addSubviewBelow(menuView, insets: .zero)
        let divider = NSView()
        divider.backgroundColor = .lightGray
        addSubviewBelow(divider, upperView: menuView, insets: .zero)
            .height(1)
        exifView.setupView()
        editView.setupView()
        editView.delegate = self
        scrollView.asVerticalScrollView(contentView: containerView)
        addSubviewBelow(scrollView, upperView: divider, insets: .zero)
            .connectToBottom(of: self)
        setImageView(currentType)
        updateView()
    }
    
    func detailImageDidChange(){
        setImageView(.exif)
    }
    
    func updateButtons(){
        if let image = image{
            switch currentType {
            case .exif:
                editButton.isHidden = false
                cancelButton.isHidden = true
            case .edit:
                editButton.isHidden = true
                cancelButton.isHidden = false
            }
            saveButton.isHidden = !image.isModified
        }
        else{
            editButton.isHidden = true
            cancelButton.isHidden = true
            saveButton.isHidden = true
        }
    }
    
    func updateView(){
        updateButtons()
        switch currentType {
        case .exif:
            exifView.update()
        case .edit:
            editView.update()
        }
    }
    
    func setImageView(_ type: ViewType){
        currentType = type
        containerView.removeAllSubviews()
        switch(type){
        case .exif:
            exifView.update()
            containerView.addSubviewFilling(exifView, insets: .zero)
        case .edit:
            editView.update()
            containerView.addSubviewFilling(editView, insets: .zero)
        }
        updateView()
    }
            
    @objc func openEditView(){
        setImageView(.edit)
    }
    
    @objc func cancelEditing(){
        image?.reloadData()
        setImageView(.exif)
        MainViewController.shared.updateDetailGridItem()
    }
    
    @objc func saveImage(){
        image?.saveModifiedFile()
        image?.isModified = false
        setImageView(.exif)
        MainViewController.shared.updateDetailGridItem()
    }
    
}

extension ImageDetailView: ImageEditViewDelegate{
    
    func imageIsModified() {
        updateButtons()
        MainViewController.shared.updateDetailGridItem()
    }
    
}





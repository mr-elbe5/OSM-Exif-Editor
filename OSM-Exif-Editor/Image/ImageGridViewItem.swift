/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Foundation
import Cocoa

class ImageGridViewItem: NSCollectionViewItem{
    
    static let fontSize: CGFloat = 12
    static let font = NSFont.systemFont(ofSize: fontSize, weight: .regular)
    
    static let centerInsets = NSEdgeInsets(top: 25, left: 5, bottom: 25, right: 5)
    static let topInsets = NSEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    static let bottomInsets = NSEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
    
    static let noLocImage = NSImage(systemSymbolName: "circle", accessibilityDescription: nil)!
    static let hasLocImage = NSImage(systemSymbolName: "map.circle", accessibilityDescription: nil)!
    
    var topView = NSView()
    var centerView = NSView()
    var bottomView = NSView()
    var nameLabel = NSTextField(labelWithString: "")
    var sortLabel = NSTextField(labelWithString: "")
    var modifiedIcon = NSImageView(image: NSImage(systemSymbolName: "pencil", accessibilityDescription: nil)!)
    var mapIcon = NSImageView(image: NSImage(systemSymbolName: "map", accessibilityDescription: nil)!)
    
    var nameView = NSTextField(labelWithString: "")
    var image: ImageData
    
    init(image: ImageData) {
        self.image = image
        super.init(nibName: "", bundle: nil)
        setHighlightState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let cellView = CellView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
        cellView.imageGridItem = self
        view = cellView
        view.backgroundColor = .yellow
        view.setGrayRoundedBorders()
        view.addSubviewWithAnchors(centerView, top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, insets: Self.centerInsets)
        view.addSubviewWithAnchors(topView, top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, insets: Self.topInsets)
            .height(20)
        view.addSubviewWithAnchors(bottomView, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, insets: Self.bottomInsets)
            .height(20)
        sortLabel.font = Self.font
        bottomView.addSubviewCentered(sortLabel, centerY: bottomView.centerYAnchor)
            .leading(bottomView.leadingAnchor, inset: 5)
        bottomView.addSubviewCentered(modifiedIcon, centerY: bottomView.centerYAnchor)
            .trailing(bottomView.trailingAnchor, inset: -25)
        bottomView.addSubviewCentered(mapIcon, centerY: bottomView.centerYAnchor)
            .trailing(bottomView.trailingAnchor, inset: -5)
        nameView.font = Self.font
        topView.addSubviewCentered(nameView, centerX: topView.centerXAnchor, centerY: topView.centerYAnchor)
        updateBottomView()
        image.completeData(){
            self.updateCenterView()
            self.updateBottomView()
        }
    }
    
    func updateCenterView(){
        centerView.removeAllSubviews()
        let imageView = NSImageView(image: image.preview)
        imageView.imageScaling = .scaleProportionallyUpOrDown
        centerView.addSubviewFilling(imageView, insets: NSEdgeInsets.smallInsets)
        updateNameView()
        updateBottomView()
        setHighlightState()
    }
    
    func updateNameView(){
        nameView.stringValue = image.url.lastPathComponent.truncateStart(to: view.bounds.width, charWidth: 10)
    }
    
    func updateBottomView(){
        if !sortString.isEmpty{
            sortLabel.stringValue = sortString
            sortLabel.isHidden = false
        }
        else{
            sortLabel.isHidden = true
        }
        modifiedIcon.isHidden = !image.isModified
        mapIcon.isHidden = !image.hasGPSData
    }
    
    var sortString: String{
        switch AppData.shared.sortType{
        case .byName:
            return image.url.lastPathComponent.truncateEnd(to: 10)
        case .byExtension:
            return image.url.pathExtension.lowercased()
        case .byFileCreation:
            return image.fileCreationDate?.dateTimeString ?? ""
        case .byFileModification:
            return image.fileModificationDate?.dateTimeString ?? ""
        case .byExifCreation:
            return image.exifCreationDate?.dateTimeString ?? ""
        case .byLatitude:
            return image.exifLatitude?.coordinateString ?? ""
        case .byLongitude:
            return image.exifLongitude?.coordinateString ?? ""
        case .byAltitude:
            if let altitude = image.exifAltitude{
                return "\(altitude) m"
            }
            return ""
        }
    }
    
    func sizeChanged(){
        updateNameView()
    }
    
    @objc func openFileWithApp(sender: AnyObject?){
        openURLWithApp(url: image.url)
    }
    
    private func openURLWithApp(url: URL?){
        if let url = url{
            let process = Process()
            process.executableURL = URL(string: "file:///usr/bin/open")
            process.arguments = [url.absoluteString]
            do{
                try process.run()
            }
            catch (let err){
                print(err)
            }
        }
    }
    
    class CellView: NSView{
        
        var imageGridItem: ImageGridViewItem?
        
        override func viewDidEndLiveResize() {
            imageGridItem?.sizeChanged()
        }
        
    }
    
    func setHighlightState() {
        view.backgroundColor = isSelected ? .selectedControlColor : .windowBackgroundColor
    }
    
}

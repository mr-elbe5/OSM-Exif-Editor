/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import AppKit
import CoreLocation

protocol TrackViewDelegate{
    func detailImagesDidChangeByTrack()
    func showTrackOnMap()
}

class TrackView: NSView {
    
    private var track: Track?{
        ImageEditContext.shared.track
    }
    
    var loadTrackButton: NSButton!
    var compareTrackButton: NSButton!
    
    var header = NSTextField(labelWithString: "track".localize())
    
    let nameView = NSTextField(wrappingLabelWithString: " ")
    let timeZoneView = NSTextField(wrappingLabelWithString: " ")
    
    let insets = NSEdgeInsets.zero
    
    var delegate: TrackViewDelegate? = nil
    
    init(){
        super.init(frame: .zero)
        loadTrackButton = NSButton(title: "loadTrack".localize(), image: NSImage(iconName: "figure.walk")!, target: self, action: #selector(loadTrack))
        compareTrackButton = NSButton(title: "compareWithTrack".localize(), image: NSImage(iconName: "point.bottomleft.forward.to.point.topright.scurvepath")!, target: self, action: #selector(compareWithTrack))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        header.font = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)
        addSubviewCenteredBelow(header, insets: .defaultInsets)
        var lastView: NSView? = header
        lastView = addLabeledView(name: "name", view: nameView, upperView: lastView, insets: insets)
        lastView = addLabeledView(name: "timeZone".localize(), view: timeZoneView, upperView: lastView, insets: insets)
        let menu = NSView()
        menu.addSubviewToRight(loadTrackButton, insets: insets)
        menu.addSubviewToLeft(compareTrackButton, insets: insets)
        addSubviewBelow(menu, upperView: lastView)
            .connectToBottom(of: self, inset: insets.bottom)
        update()
        checkButtons()
    }
    
    func checkButtons(){
        compareTrackButton.isHidden = ImageEditContext.shared.track == nil
    }
    
    func update(){
        if let track = track{
            nameView.stringValue = track.name
        }
        else{
            nameView.stringValue = ""
        }
    }
    
    @objc func loadTrack(){
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.directoryURL = BasePaths.homeDirURL
        panel.allowedContentTypes = [.gpx]
        if panel.runModal() == .OK{
            if let url = panel.urls.first{
                Track.loadFromFile(gpxUrl: url){ track in
                    track.updateFromTrackpoints()
                    ImageEditContext.shared.track = track
                    ImageEditContext.shared.setTrackTimeZone()
                    self.delegate?.showTrackOnMap()
                }
            }
        }
    }
    
    @objc func compareWithTrack(){
        if ImageEditContext.shared.selectImagesWithCloseCreationDate(){
            ImageEditContext.shared.setDetailImage(nil)
            delegate?.detailImagesDidChangeByTrack()
            MainViewController.shared.updateImageGrid()
        }
    }
    
    func updateTimeZone(){
        timeZoneView.stringValue = ImageEditContext.shared.trackTimeZone.identifier
    }
}



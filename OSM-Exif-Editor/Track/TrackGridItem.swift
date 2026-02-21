/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import AppKit

class TrackGridItem: GridItem, TrackGridItemViewDelegate{
    
    var trackItem: TrackItem{
        item as! TrackItem
    }
    
    init(track: TrackItem) {
        super.init(item: track)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let itemView = TrackGridItemView()
        itemView.delegate = self
        
        view = itemView
        view.wantsLayer = true
        view.setGrayRoundedBorders()
        
        let dateView = NSTextField(labelWithString: trackItem.creationDate.dateTimeString())
        view.addSubviewWithAnchors(dateView, top: view.topAnchor, insets: OSInsets.smallInsets).centerX(view.centerXAnchor)
        
        let imgView = NSImageView(image: trackItem.getPreview() ?? NSImage(named: "gear.grey")!)
        view.addSubviewFilling(imgView, insets: NSEdgeInsets(top: 25, left: 5, bottom: 25, right: 5))
        
        let iconView = NSView()
        view.addSubviewWithAnchors(iconView, bottom: view.bottomAnchor, insets: OSInsets.smallInsets).centerX(view.centerXAnchor)
        
        let showOnMapButton = NSButton(image: NSImage(systemSymbolName: "map", accessibilityDescription: nil)!, target: itemView, action: #selector(itemView.showTrackOnMap))
        showOnMapButton.bezelStyle = .smallSquare
        iconView.addSubviewWithAnchors(showOnMapButton, top: iconView.topAnchor, leading: iconView.leadingAnchor, bottom: iconView.bottomAnchor, insets: OSInsets.flatInsets)
        let imagesButton = NSButton(icon: "photo.stack", color: .lightColor, backgroundColor: .darkColor, target: itemView, action: #selector(showTrackImages))
        imagesButton.bezelStyle = .smallSquare
        iconView.addSubviewWithAnchors(imagesButton, top: iconView.topAnchor, leading: showOnMapButton.trailingAnchor, bottom: iconView.bottomAnchor, insets: OSInsets.flatInsets)
    }
    
    @objc func showTrackImages(){
        let images = AppData.shared.getImagesOfTrack(item: trackItem)
        MainViewController.shared.showImages(images)
    }
    
    func showTrackOnMap() {
        MainViewController.shared.showTrackOnMap(trackItem)
    }

}

fileprivate protocol TrackGridItemViewDelegate{
    func showTrackOnMap()
    func showTrackImages()
}

fileprivate class TrackGridItemView: NSView{
    
    var delegate: TrackGridItemViewDelegate? = nil
    
    @objc func showTrackOnMap(){
        delegate?.showTrackOnMap()
    }
    
    @objc func showTrackImages(){
        delegate?.showTrackImages()
    }
    
}




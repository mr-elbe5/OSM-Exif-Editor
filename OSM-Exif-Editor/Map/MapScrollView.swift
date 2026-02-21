/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation

class MapScrollView : PlainMapScrollView{
    
    override var zoom: Int{
        get{
            MapStatus.shared.zoom
        }
        set{
            MapStatus.shared.scale = World.downScale(to: newValue)
        }
    }
    
    override var zoomScale : Double{
        get{
            MapStatus.shared.scale
        }
    }
    
    var trackLayerView = TrackLayerView()
    var itemLayerView = ItemLayerView()
    
    override func setupView(){
        hasVerticalScroller = false
        hasHorizontalScroller = false
        let clipView = FlippedClipView()
        contentView = clipView
        contentView.setAnchors(top:clipView.topAnchor, leading: clipView.leadingAnchor, trailing: clipView.trailingAnchor)
        clipView.drawsBackground = false
        mapWorldView.frame = World.scaledWorld(zoom: MapStatus.shared.zoom)
        documentView = mapWorldView
        
        tileLayerView.setupView()
        mapWorldView.addSubviewFilling(tileLayerView, insets: .zero)
        
        trackLayerView.setupView()
        mapWorldView.addSubviewFilling(trackLayerView, insets: .zero)
        
        itemLayerView.setupView()
        itemLayerView.dragDelegate = self
        mapWorldView.addSubviewFilling(itemLayerView, insets: .zero)
        
        updateLayerPositions()
        addScrollNotifications()
    }
    
    func updateItemLayerContent(){
        itemLayerView.updateContent(scale: zoomScale)
    }
    
    func updateItemPositions(){
        itemLayerView.updatePosition(scale: zoomScale)
    }
    
    func updateTrackLayerContent(){
        if VisibleTrack.shared.isPresent{
            trackLayerView.updatePosition(scale: zoomScale)
        }
        else{
            trackLayerView.needsDisplay = true
        }
    }
    
    func updateTrackPosition(){
        trackLayerView.updatePosition(scale: zoomScale)
    }
    
    
    func updateLayerPositions(){
        updateItemPositions()
        updateTrackPosition()
    }
    
    func updateLayerContents(){
        updateItemLayerContent()
        updateTrackLayerContent()
    }
    
    override func scrollWheel(with event: NSEvent) {
        if !event.modifierFlags.contains(.option){
            super.scrollWheel(with: event)
            return
        }
        let dy = event.deltaY
        if dy > 0.0 {
            zoomIn()
        }
        else if dy < 0.0{
            zoomOut()
        }
        updateLayerContents()
    }
    
    @objc override func scrollViewDidScroll(){
        MapStatus.shared.centerCoordinate = screenCenterCoordinate
        updateLayerPositions()
        mapDelegate?.didScroll(to: screenCenterCoordinate)
    }
    
}

extension MapScrollView: DragDelegate{
    
    func mouseDragged(dx: CGFloat, dy: CGFloat){
        scrollBy(dx: -dx, dy: -dy)
        MapStatus.shared.centerCoordinate = screenCenterCoordinate
        mapDelegate?.didScroll(to: screenCenterCoordinate)
    }
    
}




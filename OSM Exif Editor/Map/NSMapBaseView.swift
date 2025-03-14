/*
 Maps For OSM
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation

class NSMapBaseView: NSScrollView {
    
    var zoom: Int = World.minZoom
    var centerCoordinate: CLLocationCoordinate2D = .init()
    
    var didSetFrame: Bool = false
    
    var tileLayerView = TileLayerView()
    
    var mapViewDelegate: MapBaseViewDelegate?
    
    override var frame: CGRect {
        didSet {
            if !didSetFrame, frame != .zero {
                didSetFrame = true
                debugPrint(frame)
                scrollTo(centerCoordinate)
            }
        }
    }
    
    var screenCenter : CGPoint{
        CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
    
    func setup(){
        hasVerticalScroller = false
        hasHorizontalScroller = false
        contentView = FlippedClipView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        contentView.drawsBackground = false
        documentView = FlippedView()
        documentView!.frame = World.scaledWorld(zoom: zoom)
        documentView!.addSubview(tileLayerView)
        tileLayerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tileLayerView.topAnchor.constraint(equalTo: documentView!.topAnchor),
            tileLayerView.leadingAnchor.constraint(equalTo: documentView!.leadingAnchor),
            tileLayerView.trailingAnchor.constraint(equalTo: documentView!.trailingAnchor),
            tileLayerView.bottomAnchor.constraint(equalTo: documentView!.bottomAnchor)
        ])
        tileLayerView.delegate = self
    }
    
    func clearTiles(){
        tileLayerView.refresh()
    }
    
    func scrollTo(_ coordinate: CLLocationCoordinate2D){
        centerCoordinate = coordinate
        scrollToCenterCoordinate()
    }
    
    private func scrollToCenterCoordinate(){
        if didSetFrame{
            let zoomScale = 1.0/World.zoomScaleToWorld(from: zoom)
            let mapPoint = CGPoint(x: World.scaledX(centerCoordinate.longitude, downScale: zoomScale), y: World.scaledY(centerCoordinate.latitude, downScale: zoomScale))
            let vRect = contentView.documentVisibleRect
            let scrollPoint = CGPoint(x: min(max(0, mapPoint.x - vRect.width/2), contentView.documentRect.width - vRect.width) ,y: min(max(0, mapPoint.y - vRect.height/2), contentView.documentRect.height - vRect.height))
            scroll(contentView, to: scrollPoint)
        }
    }
    
    func zoomTo(_ zoom: Int){
        if zoom >= World.minZoom && zoom <= World.maxZoom{
            self.zoom = zoom
            documentView!.setFrameSize(World.scaledWorld(zoom: zoom).size)
            tileLayerView.refresh()
            scrollToCenterCoordinate()
        }
    }
    
    override func scrollWheel(with event: NSEvent) {
        if !event.modifierFlags.contains(.option){
            super.scrollWheel(with: event)
            return
        }
        let dy = event.deltaY
        if dy > 0.0 {
            zoomTo(zoom + 1)
        }
        else if dy < 0.0{
            zoomTo(zoom - 1)
        }
    }
    
}

extension NSMapBaseView: TileLayerDelegate{
    
    func getZoom() -> Int {
        zoom
    }
    
    func mouseDragged(dx: CGFloat, dy: CGFloat){
        let zoomScale = 1.0/World.zoomScaleToWorld(from: zoom)
        scroll(contentView, to: CGPoint(x: documentVisibleRect.origin.x - dx, y: documentVisibleRect.origin.y - dy))
        let centerPoint = screenCenter
        let mapPoint = CGPoint(x: (centerPoint.x + documentVisibleRect.origin.x)/zoomScale, y: (centerPoint.y + documentVisibleRect.origin.y)/zoomScale)
        self.centerCoordinate = World.coordinate(worldX: mapPoint.x, worldY: mapPoint.y)
        mapViewDelegate?.centerChanged(to: centerCoordinate)
    }
    
}

fileprivate class FlippedView: NSView{
    
    override var isFlipped: Bool {
        return true
    }
    
}

fileprivate final class FlippedClipView: NSClipView {
    
    override var isFlipped: Bool {
        return true
    }
    
}


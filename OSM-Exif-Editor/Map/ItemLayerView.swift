/*
 OSM Maps (Mac)
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation

protocol ClickDelegate{
    func clicked(with event: NSEvent)
}

protocol DragDelegate{
    func mouseDragged(dx: CGFloat, dy: CGFloat)
}

class ItemLayerView: LayerView {
    
    var clickDelegate: ClickDelegate? = nil
    var dragDelegate: DragDelegate? = nil
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool{
        return false
    }
    
    override func mouseDown(with event: NSEvent) {
        clickDelegate?.clicked(with: event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        if event.type == .leftMouseDragged{
            dragDelegate?.mouseDragged(dx: event.deltaX, dy: event.deltaY)
        }
    }
    
    override func updatePosition(scale: CGFloat){
        self.scale = scale
        for subview in subviews{
            if let marker = subview as? ItemMarkerView{
                let mapPoint = marker.item.worldPoint
                marker.updatePosition(to: CGPoint(x: mapPoint.x*scale , y: mapPoint.y*scale))
            }
        }
        needsDisplay = true
    }
    
    override func updateContent(scale: CGFloat){
        //Log.debug("updateContent")
        self.scale = scale
        for subview in subviews {
            subview.removeFromSuperview()
        }
        for item in AppData.shared.images{
            if !item.hasValidCoordinate{
                continue
            }
            let marker = ItemMarkerView(item: item, target: self, action: #selector(showItemDetails))
            addSubview(marker)
        }
        updatePosition(scale: scale)
    }
    
    func getMarker(item: MapItem) -> MarkerView?{
        for subview in subviews{
            if let marker = subview as? ItemMarkerView, marker.item.id == item.id{
                return marker
            }
        }
        return nil
    }
    
    func updateItemStatus(_ item: MapItem){
        if let marker = getMarker(item: item){
            marker.updateImage()
        }
    }
    
    @objc func showItemDetails(sender: AnyObject?){
        if let marker = sender as? ItemMarkerView{
            MainViewController.shared.showItemDetails(item: marker.item)
        }
    }
    
}





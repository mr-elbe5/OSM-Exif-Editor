/*
 OSM Maps (Mac)
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

class ImageMarkerView : NSButton{
    
    static var size : CGFloat{32}
    static var baseFrame = CGRect(x: -size/2,y: -size, width: size, height: size)
    
    var imageData : ImageData
    
    init(image: ImageData, target: AnyObject?, action: Selector?){
        self.imageData = image
        super.init(frame: .zero)
        self.target = target
        self.action = action
        isBordered = false
        self.image = MapDefaults.mapImageIcon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePosition(to pos: CGPoint){
        //Log.debug("marker positon: \(pos)")
        frame = Self.baseFrame.offsetBy(dx: pos.x, dy: pos.y + 2)
        needsDisplay = true
    }
    
}



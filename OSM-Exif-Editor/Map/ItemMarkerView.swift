/*
 OSM Maps (Mac)
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

class ItemMarkerView : MarkerView{
    
    var item : MapItem
    
    override var hasMedia : Bool{
        item is ImageItem
    }
    
    override var hasTrack : Bool{
        item is TrackItem
    }
    
    init(item: MapItem, target: AnyObject?, action: Selector?){
        self.item = item
        super.init(frame: .zero)
        self.target = target
        self.action = action
        isBordered = false
        updateImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateImage(){
        if hasMedia{
            image = MapDefaults.mapImageIcon
        }
        else if hasTrack || hasRoute{
            image = MapDefaults.mapTrackIcon
        }
    }
    
}



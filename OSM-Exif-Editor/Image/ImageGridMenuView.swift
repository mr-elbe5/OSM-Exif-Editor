/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

protocol ImageGridMenuDelegate{
    func increasePreviewSize()
    func decreasePreviewSize()
    func selectAll()
    func deselectAll()
}

class ImageGridMenuView: NSView{
    
    var selectButton: NSButton!
    var increaseSizeButton: NSButton!
    var decreaseSizeButton: NSButton!
    
    var selectMenu: NSMenu!
    
    var delegate: ImageGridMenuDelegate? = nil
    
    var insets = OSInsets(top: 10, left: 5, bottom: 10, right: 5)
    
    init(){
        super.init(frame: .zero)
        selectButton = NSButton(icon: "checkmark.square", target: self, action: #selector(openSelectMenu))
        selectButton.toolTip = "selection".localize()
        selectMenu = NSMenu(title: "selection".localize())
        selectMenu.items.append(NSMenuItem(title: "selectAll".localize(), target: self, action: #selector(selectAllItems), keyEquivalent: ""))
        selectMenu.items.append(NSMenuItem(title: "deselectAll".localize(), target: self, action: #selector(deselectAllItems), keyEquivalent: ""))
        increaseSizeButton = NSButton(icon: "plus.circle", target: self, action: #selector(increasePreviewSize))
        increaseSizeButton.toolTip = "increaseImageSize".localize()
        decreaseSizeButton = NSButton(icon: "minus.circle", target: self, action: #selector(decreasePreviewSize))
        decreaseSizeButton.toolTip = "decreaseImageSize".localize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openSelectMenu(){
        let location = NSPoint(x: selectButton.frame.width - 2, y: 10)
        selectMenu.popUp(positioning: nil, at: location, in: selectButton)
    }
    
    @objc func selectAllItems(){
        delegate?.selectAll()
    }
    
    @objc func deselectAllItems(){
        delegate?.deselectAll()
    }
    
    @objc func increasePreviewSize() {
        delegate?.increasePreviewSize()
    }
    
    @objc func decreasePreviewSize() {
        delegate?.decreasePreviewSize()
    }
    
}
    

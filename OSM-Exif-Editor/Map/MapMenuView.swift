/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

class MapMenuView: NSView{
    
    var zoomInButton: NSButton!
    var zoomOutButton: NSButton!
    var refreshButton: NSButton!
    
    var insets = NSEdgeInsets(top: NSEdgeInsets.defaultInset, left: NSEdgeInsets.smallInset, bottom: NSEdgeInsets.defaultInset, right: NSEdgeInsets.smallInset)
    
    init(){
        super.init(frame: .zero)
        
        zoomInButton = NSButton(icon: "plus", target: self, action: #selector(zoomIn))
        zoomInButton.toolTip = "zoomIn".localize()
        zoomOutButton = NSButton(icon: "minus", target: self, action: #selector(zoomOut))
        zoomOutButton.toolTip = "zoomOut".localize()
        refreshButton = NSButton(icon: "arrow.clockwise", target: self, action: #selector(refreshMap))
        refreshButton.toolTip = "refresh".localize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView(){
        addSubviewBelow(zoomInButton, insets: insets)
        addSubviewBelow(zoomOutButton, upperView: zoomInButton, insets: insets)
        addSubviewBelow(refreshButton, upperView: zoomOutButton, insets: insets)
    }
    
    @objc func zoomIn(){
        MainViewController.shared.zoomIn()
    }
    
    @objc func zoomOut(){
        MainViewController.shared.zoomOut()
    }
    
    @objc func refreshMap() {
        MainViewController.shared.refreshMap()
    }
    
}
    

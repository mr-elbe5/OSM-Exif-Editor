/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

class MapMenuView: NSView{
    
    var zoomInButton: NSButton!
    var zoomOutButton: NSButton!
    var toggleCrossButton: NSButton!
    var toggleMapPinsButton: NSButton!
    var centerButton: NSButton!
    var refreshButton: NSButton!
    
    var insets = OSInsets(top: OSInsets.defaultInset, left: OSInsets.smallInset, bottom: OSInsets.defaultInset, right: OSInsets.smallInset)
    
    init(){
        super.init(frame: .zero)
        
        zoomInButton = NSButton(icon: "plus", target: self, action: #selector(zoomIn))
        zoomInButton.toolTip = "zoomIn".localize()
        zoomOutButton = NSButton(icon: "minus", target: self, action: #selector(zoomOut))
        zoomOutButton.toolTip = "zoomOut".localize()
        toggleCrossButton = NSButton(icon: "plus.circle", target: self, action: #selector(toggleCross))
        toggleCrossButton.toolTip = "toggleCross".localize()
        toggleMapPinsButton = NSButton(icon: "mappin.slash", target: self, action: #selector(toggleMapPins))
        toggleMapPinsButton.toolTip = "toggleMapPins".localize()
        refreshButton = NSButton(icon: "arrow.clockwise", target: self, action: #selector(refreshMap))
        refreshButton.toolTip = "refresh".localize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView(){
        addSubviewBelow(zoomInButton, insets: insets)
        addSubviewBelow(zoomOutButton, upperView: zoomInButton, insets: insets)
        addSubviewBelow(toggleCrossButton, upperView: zoomOutButton, insets: insets)
        addSubviewBelow(toggleMapPinsButton, upperView: toggleCrossButton, insets: insets)
        addSubviewBelow(refreshButton, upperView: toggleMapPinsButton, insets: insets)
    }
    
    @objc func zoomIn(){
        MainViewController.shared.zoomIn()
    }
    
    @objc func zoomOut(){
        MainViewController.shared.zoomOut()
    }
    
    @objc func toggleCross() {
        MainViewController.shared.toggleCross()
    }
    
    @objc func toggleMapPins() {
        MainViewController.shared.toggleMapPins()
    }
    
    @objc func refreshMap() {
        MainViewController.shared.refreshMap()
    }
    
}
    

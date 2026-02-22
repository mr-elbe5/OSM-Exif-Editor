/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

protocol ImageGridMenuDelegate: GridMenuDelegate{
    func showSelected()
}

class ImageGridMenuView: GridMenuView{
    
    var showPresenterButton: NSButton!
    
    override init(){
        super.init()
        showPresenterButton = NSButton(icon: "photo.badge.magnifyingglass", target: self, action: #selector(showSelected))
        showPresenterButton.toolTip = "showSelectedImages".localize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView(){
        addSubviewBelow(selectButton, insets: insets)
        addSubviewBelow(showPresenterButton, upperView: selectButton, insets: insets)
        addSubviewBelow(increaseSizeButton, upperView: showPresenterButton, insets: insets)
        addSubviewBelow(decreaseSizeButton, upperView: increaseSizeButton, insets: insets)
    }
    
    @objc func showSelected() {
        (delegate as? ImageGridMenuDelegate)?.showSelected()
    }
    
}
    

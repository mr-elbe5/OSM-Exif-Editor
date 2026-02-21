/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

protocol ImageGridMenuDelegate: GridMenuDelegate{
    func showSelected()
    func importImagesFromFiles()
}

class ImageGridMenuView: GridMenuView{
    
    var showPresenterButton: NSButton!
    var importImagesFromFilesButton: NSButton!
    
    override init(){
        super.init()
        showPresenterButton = NSButton(icon: "photo.badge.magnifyingglass", target: self, action: #selector(showSelected))
        showPresenterButton.toolTip = "showSelectedImages".localize()
        importImagesFromFilesButton = NSButton(icon: "square.and.arrow.down.fill", target: self, action: #selector(importImagesFromFiles))
        importImagesFromFilesButton.toolTip = "importImagesFromFiles".localize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView(){
        addSubviewBelow(selectButton, insets: insets)
        addSubviewBelow(showPresenterButton, upperView: selectButton, insets: insets)
        addSubviewBelow(increaseSizeButton, upperView: showPresenterButton, insets: insets)
        addSubviewBelow(decreaseSizeButton, upperView: increaseSizeButton, insets: insets)
        addSubviewBelow(importImagesFromFilesButton, upperView: decreaseSizeButton, insets: insets)
        addSubviewBelow(deleteButton, upperView: importImagesFromFilesButton, insets: insets)
    }
    
    @objc func showSelected() {
        (delegate as? ImageGridMenuDelegate)?.showSelected()
    }
    
    @objc func importImagesFromFiles(){
        (delegate as? ImageGridMenuDelegate)?.importImagesFromFiles()
    }
    
}
    

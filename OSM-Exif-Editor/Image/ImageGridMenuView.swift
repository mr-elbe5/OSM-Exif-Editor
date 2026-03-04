/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

protocol ImageGridMenuViewDelegate{
    func selectAllItems()
    func deselectAllItems()
    func updateItemSize()
    func showSelectedItems()
}

class ImageGridMenuView: NSView {
    
    var selectAllButton: NSButton!
    var deselectAllButton: NSButton!
    var increaseSizeButton: NSButton!
    var decreaseSizeButton: NSButton!
    var showPresenterButton: NSButton!
    var saveSelectedButton: NSButton!
    var exportSelectedButton: NSButton!
    var deleteSelectedButton: NSButton!
    
    var delegate: ImageGridMenuViewDelegate? = nil
    
    var insets = NSEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    
    override func setupView() {
        selectAllButton = NSButton(icon: "checkmark.square", target: self, action: #selector(selectAllItems)).asMenuButton()
        selectAllButton.toolTip = "selectAll".localize()
        deselectAllButton = NSButton(icon: "square", target: self, action: #selector(deselectAllItems)).asMenuButton()
        deselectAllButton.toolTip = "deselectAll".localize()
        increaseSizeButton = NSButton(icon: "plus", target: self, action: #selector(increaseCellSize)).asMenuButton()
        increaseSizeButton.toolTip = "increaseImageSize".localize()
        decreaseSizeButton = NSButton(icon: "minus", target: self, action: #selector(decreaseCellSize)).asMenuButton()
        decreaseSizeButton.toolTip = "decreaseImageSize".localize()
        showPresenterButton = NSButton(icon: "magnifyingglass", target: self, action: #selector(showSelected)).asMenuButton()
        showPresenterButton.toolTip = "showSelectedImages".localize()
        saveSelectedButton = NSButton(icon: "checkmark.circle.fill", target: self, action: #selector(saveSelectedImages)).asMenuButton()
        saveSelectedButton.toolTip = "saveSelectedImages".localize()
        exportSelectedButton = NSButton(icon: "square.and.arrow.up", target: self, action: #selector(exportSelectedImages)).asMenuButton()
        exportSelectedButton.toolTip = "exportSelectedImages".localize()
        deleteSelectedButton = NSButton(icon: "trash", color: .red, target: self, action: #selector(deleteSelectedImages)).asMenuButton()
        deleteSelectedButton.toolTip = "deleteSelectedImages".localize()
        
        addSubviewBelow(selectAllButton, insets: insets)
        addSubviewBelow(deselectAllButton, upperView: selectAllButton, insets: insets)
        addSubviewBelow(increaseSizeButton, upperView: deselectAllButton, insets: insets)
        addSubviewBelow(decreaseSizeButton, upperView: increaseSizeButton, insets: insets)
        addSubviewBelow(showPresenterButton, upperView: decreaseSizeButton, insets: insets)
        addSubviewBelow(saveSelectedButton, upperView: showPresenterButton, insets: insets)
        addSubviewBelow(exportSelectedButton, upperView: saveSelectedButton, insets: insets)
        addSubviewBelow(deleteSelectedButton, upperView: exportSelectedButton, insets: insets)
    }
    
    @objc func selectAllItems(){
        delegate?.selectAllItems()
    }
    
    @objc func deselectAllItems(){
        delegate?.deselectAllItems()
    }
    
    @objc func increaseCellSize() {
        if Preferences.shared.gridSizeFactorIndex < ImageGridView.gridSizeFactors.count - 1{
            Preferences.shared.gridSizeFactorIndex += 1
            delegate?.updateItemSize()
        }
    }
    
    @objc func decreaseCellSize() {
        if Preferences.shared.gridSizeFactorIndex > 0{
            Preferences.shared.gridSizeFactorIndex -= 1
            delegate?.updateItemSize()
        }
    }
    
    @objc func showSelected(){
        delegate?.showSelectedItems()
    }
    
    @objc func saveSelectedImages(){
        MainViewController.shared.saveSelectedImages()
    }
    
    @objc func exportSelectedImages(){
        MainViewController.shared.exportSelectedImages()
    }
    
    @objc func deleteSelectedImages(){
        MainViewController.shared.deleteSelectedImages()
    }
    
}

extension NSButton{
    
    @discardableResult
    func asMenuButton() -> NSButton{
        self.symbolConfiguration = .init(pointSize: 16, weight: .regular)
        self.bezelStyle = .smallSquare
        self.width(24)
        self.height(24)
        return self
    }
    
}



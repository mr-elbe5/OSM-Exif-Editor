/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

protocol ImageGridHeaderViewDelegate{
    func didChangeSortType()
}

class ImageGridHeaderView: NSView {
    
    let headerLabel = NSTextField(labelWithString: "")
    let sortLabel = NSTextField(labelWithString: "sorting".localize() + ": ")
    var sortButton: NSPopUpButton!
    var sortMenu = NSMenu()
    
    var delegate: ImageGridHeaderViewDelegate? = nil
    
    override func setupView() {
        let label = NSTextField(labelWithString: "folder".localize() + ": ")
        addSubviewToRight(label)
        addSubviewToRight(headerLabel, leftView: label)
        let bufferView = NSView()
        addSubviewToRight(bufferView, leftView: headerLabel)
        
        sortMenu = NSMenu()
        for sortType in ImageSortType.allCases{
            let item = NSMenuItem(title: sortType.localizedName, target: self, action: #selector(sort), keyEquivalent: "")
            item.representedObject = sortType
            sortMenu.items.append(item)
        }
        sortMenu.selectionMode = .selectOne
        let sortIdx = ImageSortType.index(of: AppData.shared.sortType)
        sortMenu.selectedItems = [sortMenu.item(at: sortIdx)!]
        sortButton = NSPopUpButton(title: sortMenu.selectedItems[0].title, pullDownMenu: sortMenu)
        sortButton.pullsDown = true
        sortButton.synchronizeTitleAndSelectedItem()
        addSubviewToLeft(sortButton)
        addSubviewToLeft(sortLabel, rightView: sortButton)
            .leading(bufferView.trailingAnchor)
    }
    
    func updateView() {
        headerLabel.stringValue = AppData.shared.name
    }
    
    @objc func sort(sender: Any?){
        if let sender = sender as? NSMenuItem, let sortType = sender.representedObject as? ImageSortType {
            if sortType == AppData.shared.sortType{
                AppData.shared.ascending = !AppData.shared.ascending
            }
            else{
                AppData.shared.sortType = sortType
                AppData.shared.ascending = true
            }
            AppData.shared.sortImages()
            sortButton.title = sortMenu.selectedItems[0].title
            delegate?.didChangeSortType()
        }
        
    }
    
}





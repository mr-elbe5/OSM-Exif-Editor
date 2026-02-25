/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Cocoa

class ImageGridView: NSView {
    
    static var defaultGridSize: CGFloat = 300
    static var gridSizeFactors : Array<CGFloat> = [0.5, 0.75, 1.0, 1.5, 2.0]
    
    var active = false
    
    let headerView = NSView()
    let headerLabel = NSTextField(labelWithString: "")
    let sortLabel = NSTextField(labelWithString: "")
    
    let menuView = NSView()
    var sortButton: NSButton!
    var selectButton: NSButton!
    var showPresenterButton: NSButton!
    var increaseSizeButton: NSButton!
    var decreaseSizeButton: NSButton!
    var exportSelectedButton: NSButton!
    
    var sortMenu: NSMenu!
    var selectMenu: NSMenu!
    
    let scrollView = NSScrollView()
    let collectionView = NSCollectionView()
    let layout = NSCollectionViewFlowLayout()
    var minSize: CGFloat = ImageGridView.defaultGridSize
    let gridSpace: CGFloat = 10
    
    var cellSize = NSSize(width: ImageGridView.defaultGridSize, height: ImageGridView.defaultGridSize)
    
    //var testView = GridView()
    
    var hasSelection: Bool{
        false
        //!collectionView.selectionIndexPaths.isEmpty
    }
    
    var gridSize: CGFloat = ImageGridView.defaultGridSize * ImageGridView.gridSizeFactors[Preferences.shared.gridSizeFactorIndex]
    
    var insets = NSEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    
    override func setupView(){
        backgroundColor = .black
        setupHeaderView()
        setupMenuView()
        setupCollectionView()
        addSubviewBelow(headerView)
        addSubviewWithAnchors(menuView, top: headerView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, insets: .narrowInsets)
        addSubviewWithAnchors(scrollView, top: headerView.bottomAnchor, leading: menuView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: .narrowInsets)
    }
    
    func setupNotifications(){
        NotificationCenter.default.addObserver(forName:  NSView.frameDidChangeNotification, object: nil, queue: nil) { notification in
            self.updateItemSize()
        }
    }
    
    func updateItemSize(){
        updateCellSize()
        layout.invalidateLayout()
    }
    
    func updateCellSize(){
        minSize = ImageGridView.defaultGridSize * ImageGridView.gridSizeFactors[Preferences.shared.gridSizeFactorIndex]
        let cnt = Int(floor(collectionView.frame.width/minSize))
        let size = (collectionView.frame.width - (CGFloat(cnt + 1)) * gridSpace)/CGFloat(cnt)
        cellSize = cnt == 0 ? .zero : NSSize(width: size, height: size)
    }
    
    func updateImageStatus(){
        for i in 0..<AppData.shared.images.count{
            if let gridItem = collectionView.item(at: i) as? ImageGridViewItem{
                gridItem.updateBottomView()
            }
        }
    }
    
    func updateDetailImageStatus(){
        if let detailImage = AppData.shared.detailImage{
            for i in 0..<AppData.shared.images.count{
                if let gridItem = collectionView.item(at: i) as? ImageGridViewItem, gridItem.image == detailImage{
                    gridItem.updateBottomView()
                    break
                }
            }
        }
    }
    
    func setupHeaderView() {
        headerView.addSubviewToRight(headerLabel)
        let bufferView = NSView()
        headerView.addSubviewToRight(headerLabel)
        headerView.addSubviewToRight(bufferView, leftView: headerLabel)
        headerView.addSubviewToLeft(sortLabel)
            .leading(bufferView.trailingAnchor)
    }
    
    func updateHeaderView() {
        headerLabel.stringValue = AppData.shared.name
        sortLabel.stringValue = "\("sorting".localize()):\(AppData.shared.sortType.localizedName)"
    }
    
    func setupMenuView() {
        sortButton = NSButton(image: NSImage(systemSymbolName: "arrow.up.arrow.down", accessibilityDescription: nil)!, target: self, action: #selector(openSortMenu)).asMenuButton()
        sortButton.toolTip = "sort".localize()
        sortMenu = NSMenu(title: "selection".localize())
        for sortType in ImageSortType.allCases{
            let item = NSMenuItem(title: sortType.localizedName, target: self, action: #selector(sort), keyEquivalent: "")
            item.representedObject = sortType
            sortMenu.items.append(item)
        }
        selectButton = NSButton(icon: "checkmark.square", target: self, action: #selector(openSelectMenu)).asMenuButton()
        selectButton.toolTip = "selection".localize()
        selectMenu = NSMenu(title: "selection".localize())
        selectMenu.items.append(NSMenuItem(title: "selectAll".localize(), target: self, action: #selector(selectAllItems), keyEquivalent: ""))
        selectMenu.items.append(NSMenuItem(title: "deselectAll".localize(), target: self, action: #selector(deselectAllItems), keyEquivalent: ""))
        showPresenterButton = NSButton(icon: "photo", target: self, action: #selector(showSelected)).asMenuButton()
        showPresenterButton.toolTip = "showSelectedImages".localize()
        increaseSizeButton = NSButton(icon: "plus", target: self, action: #selector(increaseCellSize)).asMenuButton()
        increaseSizeButton.toolTip = "increaseImageSize".localize()
        decreaseSizeButton = NSButton(icon: "minus", target: self, action: #selector(decreaseCellSize)).asMenuButton()
        decreaseSizeButton.toolTip = "decreaseImageSize".localize()
        
        menuView.addSubviewBelow(sortButton, insets: insets)
        menuView.addSubviewBelow(selectButton, upperView: sortButton, insets: insets)
        menuView.addSubviewBelow(showPresenterButton, upperView: selectButton, insets: insets)
        menuView.addSubviewBelow(increaseSizeButton, upperView: showPresenterButton, insets: insets)
        menuView.addSubviewBelow(decreaseSizeButton, upperView: increaseSizeButton, insets: insets)
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.allowsEmptySelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.isSelectable = true
        collectionView.delegate = self
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.documentView = collectionView
        layout.minimumInteritemSpacing = gridSpace
        layout.minimumLineSpacing = gridSpace
        updateItemSize()
        collectionView.collectionViewLayout = layout
        updateHeaderView()
        collectionView.dataSource = AppData.shared
    }
    
    @objc func increaseCellSize() {
        if Preferences.shared.gridSizeFactorIndex < ImageGridView.gridSizeFactors.count - 1{
            Preferences.shared.gridSizeFactorIndex += 1
            updateItemSize()
        }
    }
    
    @objc func decreaseCellSize() {
        if Preferences.shared.gridSizeFactorIndex > 0{
            Preferences.shared.gridSizeFactorIndex -= 1
            updateItemSize()
        }
    }
    
    func updateView(){
        collectionView.removeAllSubviews()
        updateCellSize()
        updateData()
    }
    
    func updateData(){
        AppData.shared.sortImages()
        collectionView.reloadData()
    }
    
    func getSelectedImages() -> Array<ImageItem>{
        var arr = Array<ImageItem>()
        for path in collectionView.selectionIndexPaths{
            arr.append(AppData.shared.images[path.item])
        }
        return arr
    }
    
    @objc func openDirectory(){
        MainViewController.shared.openFolder()
    }
    
    @objc func openSortMenu(){
        let location = NSPoint(x: sortButton.frame.width - 2, y: 10)
        sortMenu.popUp(positioning: nil, at: location, in: sortButton)
    }
    
    @objc func openSelectMenu(){
        let location = NSPoint(x: selectButton.frame.width - 2, y: 10)
        selectMenu.popUp(positioning: nil, at: location, in: selectButton)
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
            updateHeaderView()
            updateView()
        }
        
    }
    
    @objc func selectAllItems(){
        collectionView.selectAll(nil)
    }
    
    @objc func deselectAllItems(){
        collectionView.deselectAll(nil)
    }
    
    @objc func showSelected(){
        let selected = getSelectedImages()
        if !selected.isEmpty{
            MainViewController.shared.showImages(selected)
        }
    }
    
}

extension ImageGridView: NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if collectionView.selectionIndexPaths.count == 1, let idx = collectionView.selectionIndexPaths.first?.item{
            MainViewController.shared.setDetailImage(AppData.shared.images[idx])
        }
        else{
            MainViewController.shared.setDetailImage(nil)
        }
        for indexPath in indexPaths{
            if let item = collectionView.item(at: indexPath) as? ImageGridViewItem{
                item.image.selected = true
                print("selected \(item.image.fileName)")
                item.setHighlightState()
            }
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        if collectionView.selectionIndexPaths.count == 1, let idx = collectionView.selectionIndexPaths.first?.item{
            MainViewController.shared.setDetailImage(AppData.shared.images[idx])
        }
        else{
            MainViewController.shared.setDetailImage(nil)
        }
        for indexPath in indexPaths{
            if let item = collectionView.item(at: indexPath) as? ImageGridViewItem{
                item.image.selected = false
                print("deselected \(item.image.fileName)")
                item.setHighlightState()
            }
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath
    ) -> NSSize{
        return cellSize
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout: NSCollectionViewLayout, insetForSectionAt: Int) -> NSEdgeInsets{
        NSEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout: NSCollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat{
        10
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat{
        10
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



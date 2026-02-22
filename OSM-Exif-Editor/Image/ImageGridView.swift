/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Cocoa

class ImageGridView: NSView {
    
    static var defaultGridSize: CGFloat = 200
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
    let layout = NSCollectionViewGridLayout()
    let gridSpace: CGFloat = 10
    
    var hasSelection: Bool{
        !collectionView.selectionIndexPaths.isEmpty
    }
    
    var gridSize: CGFloat{
        ImageGridView.defaultGridSize * ImageGridView.gridSizeFactors[Preferences.shared.gridSizeFactorIndex]
    }
    
    var insets = OSInsets(top: 10, left: 5, bottom: 10, right: 5)
    
    override func setupView(){
        backgroundColor = .black
        setupHeaderView()
        setupMenuView()
        setupCollectionView()
        addSubviewBelow(headerView)
        addSubviewWithAnchors(menuView, top: headerView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, insets: .narrowInsets)
        addSubviewWithAnchors(scrollView, top: headerView.bottomAnchor, leading: menuView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: .narrowInsets)
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
        sortLabel.stringValue = "\("sorting".localize()): \(AppData.shared.sortType.localizedName)"
    }
    
    func setupMenuView() {
        sortButton = NSButton(image: NSImage(systemSymbolName: "arrow.up.arrow.down", accessibilityDescription: nil)!, target: self, action: #selector(openSortMenu)).asMenuButton()
        sortButton.toolTip = "sort".localize()
        sortMenu = NSMenu(title: "selection".localize())
        for sortType in SortType.allCases{
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
    
    override func viewDidEndLiveResize() {
        updateItemSize()
    }
    
    func updateItemSize(){
        let gridSize = gridSize
        layout.minimumItemSize = CGSize(width: gridSize * 0.75, height: gridSize * 0.75)
        layout.maximumItemSize = CGSize(width: gridSize * 1.25, height: gridSize * 1.25)
        needsDisplay = true
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
        MainViewController.shared.setDetailImage(image: nil)
        collectionView.removeAllSubviews()
        updateData()
        updateItemSize()
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
    
    func selectedImageChanged(image: ImageItem){
        MainViewController.shared.updateDetailImage(image: image)
    }
    
    func showImageFullSize(image: ImageItem){
        
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
        if let sender = sender as? NSMenuItem, let sortType = sender.representedObject as? SortType {
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

extension ImageGridView: NSCollectionViewDelegate{
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if collectionView.selectionIndexPaths.count == 1, let idx = collectionView.selectionIndexPaths.first?.item{
            MainViewController.shared.setDetailImage(image: AppData.shared.images[idx])
        }
        else{
            MainViewController.shared.setDetailImage(image: nil)
        }
        for indexPath in indexPaths{
            if let item = collectionView.item(at: indexPath) as? ImageCell{
                item.image.selected = true
                print("selected \(item.image.fileName)")
                item.setHighlightState()
            }
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        if collectionView.selectionIndexPaths.count == 1, let idx = collectionView.selectionIndexPaths.first?.item{
            MainViewController.shared.setDetailImage(image: AppData.shared.images[idx])
        }
        else{
            MainViewController.shared.setDetailImage(image: nil)
        }
        for indexPath in indexPaths{
            if let item = collectionView.item(at: indexPath) as? ImageCell{
                item.image.selected = false
                print("deselected \(item.image.fileName)")
                item.setHighlightState()
            }
        }
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



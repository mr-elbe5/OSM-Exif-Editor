/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Cocoa

class ImageGridView: NSView {
    
    static var defaultGridWidth: CGFloat = 300
    static var defaultGridSize = NSSize(width: defaultGridWidth, height: defaultGridWidth)
    static var gridSizeFactors : Array<CGFloat> = [0.5, 0.75, 1.0, 1.5, 2.0]
    
    var active = false
    
    let headerView = ImageGridHeaderView()
    let menuView = ImageGridMenuView()
    
    let scrollView = NSScrollView()
    let collectionView = NSCollectionView()
    let layout = NSCollectionViewFlowLayout()
    var minSize: CGFloat = ImageGridView.defaultGridWidth
    let gridSpace: CGFloat = 10
    
    var cellSize = NSSize(width: ImageGridView.defaultGridWidth, height: ImageGridView.defaultGridWidth)
    
    var gridSize: CGFloat = ImageGridView.defaultGridWidth * ImageGridView.gridSizeFactors[Preferences.shared.gridSizeFactorIndex]
    
    var insets = NSEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    
    override func setupView(){
        backgroundColor = .black
        headerView.setupView()
        headerView.delegate = self
        setupNotifications()
        menuView.setupView()
        menuView.delegate = self
        setupCollectionView()
        addSubviewBelow(headerView)
        addSubviewWithAnchors(menuView, top: headerView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, insets: .narrowInsets)
        addSubviewWithAnchors(scrollView, top: headerView.bottomAnchor, leading: menuView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: .narrowInsets)
        headerView.updateView()
    }
    
    func setupNotifications(){
        NotificationCenter.default.addObserver(forName:  NSView.frameDidChangeNotification, object: nil, queue: nil) { notification in
            self.updateItemSize()
        }
    }
    
    func updateCellSize(){
        minSize = ImageGridView.defaultGridWidth * ImageGridView.gridSizeFactors[Preferences.shared.gridSizeFactorIndex]
        let cnt = Int(floor(collectionView.frame.width/minSize))
        let size = (collectionView.frame.width - (CGFloat(cnt + 1)) * gridSpace)/CGFloat(cnt)
        cellSize = cnt == 0 ? Self.defaultGridSize : NSSize(width: size, height: size)
    }
    
    func updateImageStatus(){
        for i in 0..<AppData.shared.images.count{
            if let gridItem = collectionView.item(at: i) as? ImageGridViewItem{
                gridItem.updateBottomView()
            }
        }
    }
    
    func updateDetailImageStatus(){
        if let detailImage = ImageEditContext.shared.detailImage{
            for i in 0..<AppData.shared.images.count{
                if let gridItem = collectionView.item(at: i) as? ImageGridViewItem, gridItem.image == detailImage{
                    gridItem.updateBottomView()
                    break
                }
            }
        }
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
        collectionView.dataSource = AppData.shared
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
    
    func getSelectedImages() -> Array<ImageData>{
        var arr = Array<ImageData>()
        for path in collectionView.selectionIndexPaths{
            arr.append(AppData.shared.images[path.item])
        }
        return arr
    }
    
    func selectImage(_ image: ImageData){
        AppData.shared.images.deselectAll()
        image.selected = true
        collectionView.reloadData()
    }
    
    @objc func openDirectory(){
        MainViewController.shared.openFolder()
    }
    
}

extension ImageGridView: ImageGridMenuViewDelegate{
    
    func selectAllItems(){
        collectionView.selectAll(nil)
    }
    
    func deselectAllItems(){
        collectionView.deselectAll(nil)
    }
    
    func updateItemSize(){
        updateCellSize()
        layout.invalidateLayout()
    }
    
    func showSelectedItems(){
        let selected = getSelectedImages()
        if !selected.isEmpty{
            MainViewController.shared.showImages(selected)
        }
    }
    
}

extension ImageGridView: ImageGridHeaderViewDelegate{
    
    func didChangeSortType() {
        collectionView.reloadData()
    }
    
}

extension ImageGridView: NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if collectionView.selectionIndexPaths.count == 1, let idx = collectionView.selectionIndexPaths.first?.item{
            ImageEditContext.shared.setDetailImage(AppData.shared.images[idx])
        }
        else{
            ImageEditContext.shared.setDetailImage(nil)
        }
        for indexPath in indexPaths{
            if let item = collectionView.item(at: indexPath) as? ImageGridViewItem{
                item.image.selected = true
                //print("selected \(item.image.fileName)")
                item.setHighlightState()
            }
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        if collectionView.selectionIndexPaths.count == 1, let idx = collectionView.selectionIndexPaths.first?.item{
            ImageEditContext.shared.setDetailImage(AppData.shared.images[idx])
        }
        else{
            ImageEditContext.shared.setDetailImage(nil)
        }
        for indexPath in indexPaths{
            if let item = collectionView.item(at: indexPath) as? ImageGridViewItem{
                item.image.selected = false
                //print("deselected \(item.image.fileName)")
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





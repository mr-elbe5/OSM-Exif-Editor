/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import AVFoundation
import CoreLocation

class MainViewController: ViewController {
    
    static var shared: MainViewController{
        get{
            MainWindowController.instance.mainViewController
        }
    }
    
    let mainMenu = MainMenuView()
    let separator = NSView()
    var mapSplitView: SplitView!
    var mapView = MapView()
    var mapDetailView = MapDetailView()
    var gridView: GridView?
    
    var mapScrollView: MapScrollView{
        mapView.scrollView
    }
    
    var mapMenuView: MapMenuView{
        mapView.menuView
    }
    
    var itemListView: ItemListView{
        mapDetailView.itemListView
    }
    
    var imageGridView: ImageGridView?{
        gridView as? ImageGridView
    }
    
    var trackGridView: TrackGridView?{
        gridView as? TrackGridView
    }
    
    override func loadView(){
        view = NSView()
        view.backgroundColor = .black
        mainMenu.setupView()
        view.addSubviewBelow(mainMenu, insets: .zero)
        separator.backgroundColor = .darkGray
        view.addSubviewBelow(separator, upperView: mainMenu, insets: .zero)
            .height(3)
        mapView.setupView()
        mapDetailView.setupView()
        mapSplitView = SplitView(mainView: mapView, sideView: mapDetailView)
        mapSplitView.setupView()
        view.addSubviewBelow(mapSplitView, upperView: separator, insets: .zero)
            .connectToBottom(of: view, inset: .zero)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        mapView.setDefaultLocation()
        mapScrollView.updateItemLayerContent()
    }
    
    func showItemDetails(item: MapItem){
        itemListView.setItems([item])
    }
    
    func setGridView(_ gridView: GridView?){
        self.gridView?.removeFromSuperview()
        if gridView == nil {
            self.gridView = nil
        }
        else{
            self.gridView = gridView
            self.gridView!.setupView()
            view.addSubviewWithAnchors(self.gridView!, top: separator.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, insets: .zero)
        }
        mainMenu.centerMenu.selectedSegment = gridView?.idx ?? 0
    }
    
    func setViewer(_ viewer: PresenterView){
        viewer.setupView()
        view.addSubviewFilling(viewer, insets: .zero)
    }
    
    // map
    
    func refreshMap() {
        showTrackOnMap(nil)
        mapView.refreshMap()
    }
    
    func updateMapLayersScale(){
        mapScrollView.updateItemPositions()
        mapScrollView.updateTrackPosition()
    }
    
    func zoomIn(){
        mapView.zoomIn()
        updateMapLayersScale()
    }
    
    func zoomOut(){
        mapView.zoomOut()
        updateMapLayersScale()
    }
    
    func toggleCross() {
        mapView.toggleCross()
    }
    
    func toggleMapPins() {
        mapView.toggleMarkers()
    }
    
    func showItemOnMap(_ item: MapItem){
        setGridView(nil)
        mapView.showLocationOnMap(coordinate: item.coordinate)
    }
    
    func showSearchResult(coordinate: CLLocationCoordinate2D, worldRect: CGRect?){
        if let worldRect = worldRect{
            let zoom = World.getZoomToFit(worldRect: worldRect, scaledSize: mapView.bounds.size)
            mapScrollView.zoomAndScrollTo(zoom, coordinate)
        }
        else{
            mapScrollView.scrollToScreenCenter(coordinate: coordinate)
        }
        updateMapLayersScale()
    }
    
    func itemsChanged(){
        mapScrollView.updateItemLayerContent()
        mapScrollView.updateTrackLayerContent()
        updateImageGrid()
        updateTrackGrid()
    }
    
    // images
    
    func showImage(_ image: ImageItem){
        let presenterView = ImagePresenterView()
        setViewer(presenterView)
        presenterView.setImage(item: image)
    }
    
    func showImages(_ images: [ImageItem]){
        let presenterView = ImagePresenterView()
        setViewer(presenterView)
        presenterView.setImages(images)
    }
    
    func showFilteredImageGrid(selectedImages: [ImageItem]){
        //AppData.shared.select
        
    }
    
    func updateImageGrid(){
        imageGridView?.updateData()
    }
    
    // tracks
    
    func showTrackOnMap(_ item: TrackItem?){
        setGridView(nil)
        if let item = item{
            VisibleTrack.shared.setTrack(item.track)
            mapScrollView.updateTrackLayerContent()
            if item.track.coordinateRegion == nil{
                item.track.updateCoordinateRegion()
            }
            if let coordinateRegion = item.coordinateRegion{
                mapView.showMapRectOnMap(worldRect: coordinateRegion.worldRect)
            }
            else{
                mapView.showLocationOnMap(coordinate: item.coordinate)
            }
        }
        else{
            VisibleTrack.shared.reset()
            mapScrollView.updateTrackLayerContent()
        }
    }
    
    func updateTrackGrid(){
        trackGridView?.updateData()
    }
    
}

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
    var mainSplitView: HorizontalSplitView!
    var imageGridView = ImageGridView()
    var sideSplitView: VerticalSplitView!
    var mapDetailView = MapDetailView()
    var mapView = MapView()
    
    var mapScrollView: MapScrollView{
        mapView.scrollView
    }
    
    var mapMenuView: MapMenuView{
        mapView.menuView
    }
    
    override func loadView(){
        view = NSView()
        view.backgroundColor = .black
        mainMenu.setupView()
        view.addSubviewBelow(mainMenu, insets: .zero)
        separator.backgroundColor = .darkGray
        view.addSubviewBelow(separator, upperView: mainMenu, insets: .zero)
            .height(3)
        imageGridView.setupView()
        mapView.setupView()
        mapDetailView.setupView()
        sideSplitView = VerticalSplitView(topView: mapDetailView, bottomView: mapView)
        sideSplitView.setupView()
        mainSplitView = HorizontalSplitView(mainView: imageGridView, sideView: sideSplitView)
        mainSplitView.setupView()
        view.addSubviewBelow(mainSplitView, upperView: separator, insets: .zero)
            .connectToBottom(of: view, inset: .zero)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        mapView.setDefaultLocation()
        mapScrollView.updateItemLayerContent()
    }
    
    func showItemDetails(item: MapItem){
        
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
    
    func showItemOnMap(_ item: MapItem){
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
        imageGridView.updateData()
    }
    
    // tracks
    
    func showTrackOnMap(_ item: TrackItem?){
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
    
}

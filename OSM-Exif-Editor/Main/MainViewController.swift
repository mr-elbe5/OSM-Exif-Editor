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
    var imageGridView = ImageGridView()
    var detailView = DetailView()
    
    var mapScrollView: MapScrollView{
        detailView.mapView.scrollView
    }
    
    var mapMenuView: MapMenuView{
        detailView.mapView.menuView
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
        detailView = DetailView()
        detailView.setupView()
        let mainSplitView = HorizontalSplitView(mainView: imageGridView, sideView: detailView)
        mainSplitView.setupView()
        view.addSubviewBelow(mainSplitView, upperView: separator, insets: .zero)
            .connectToBottom(of: view, inset: .zero)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        detailView.mapView.setDefaultLocation()
        mapScrollView.updateItemLayerContent()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        imageGridView.setupNotifications()
    }
    
    func setViewer(_ viewer: PresenterView){
        viewer.setupView()
        view.addSubviewFilling(viewer, insets: .zero)
    }
    
    // map
    
    func refreshMap() {
        showTrackOnMap(nil)
        detailView.mapView.refreshMap()
    }
    
    func updateMapLayersScale(){
        mapScrollView.updateItemPositions()
        mapScrollView.updateTrackPosition()
    }
    
    func zoomIn(){
        detailView.mapView.zoomIn()
        updateMapLayersScale()
    }
    
    func zoomOut(){
        detailView.mapView.zoomOut()
        updateMapLayersScale()
    }
    
    func showImageOnMap(_ image: ImageData){
        if let coordinate = image.coordinate{
            detailView.mapView.showLocationOnMap(coordinate: coordinate)
        }
    }
    
    func showImageDetails(image: ImageData){
        
    }
    
    func showSearchResult(coordinate: CLLocationCoordinate2D, worldRect: CGRect?){
        if let worldRect = worldRect{
            let zoom = World.getZoomToFit(worldRect: worldRect, scaledSize: detailView.mapView.bounds.size)
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
    
    func showImage(_ image: ImageData){
        let presenterView = ImagePresenterView()
        setViewer(presenterView)
        presenterView.setImage(image: image)
    }
    
    func showImages(_ images: [ImageData]){
        let presenterView = ImagePresenterView()
        setViewer(presenterView)
        presenterView.setImages(images)
    }
    
    func updateImageGrid(){
        imageGridView.updateData()
    }
    
    func updateDetailView(){
        detailView.detailImageDidChange()
    }
    
    func setDetailImage(_ image: ImageData?){
        AppData.shared.setDetailImage(image)
        updateDetailView()
    }
    
    func updateDetailGridItem(){
        imageGridView.updateDetailImageStatus()
    }
    
    // tracks
    
    func loadTrack(){
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.directoryURL = BasePaths.homeDirURL
        panel.allowedContentTypes = [.gpx]
        if panel.runModal() == .OK{
            if let url = panel.urls.first, let track = Track.loadFromFile(gpxUrl: url){
                track.updateFromTrackpoints()
                AppData.shared.track = track
                showTrackOnMap(track)
            }
        }
    }
    
    func showTrackOnMap(_ track: Track?){
        if let track = track{
            VisibleTrack.shared.setTrack(track)
            mapScrollView.updateTrackLayerContent()
            if track.coordinateRegion == nil{
                track.updateCoordinateRegion()
            }
            if let coordinateRegion = track.coordinateRegion{
                detailView.mapView.showMapRectOnMap(worldRect: coordinateRegion.worldRect)
            }
            else if let coordinate = track.startCoordinate{
                detailView.mapView.showLocationOnMap(coordinate: coordinate)
            }
        }
        else{
            VisibleTrack.shared.reset()
            mapScrollView.updateTrackLayerContent()
        }
    }
    
    func compareWithTrack(){
        if AppData.shared.selectImagesWithCloseCreationDate(){
            AppData.shared.setDetailImage(nil)
            imageGridView.updateView()
            detailView.detailImagesDidChangeByTrack()
        }
    }
    
    // menu
    
    func openHelp(at button: NSButton) {
        let controller = HelpViewController()
        controller.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    func openPreferences(at button: NSButton) {
        let controller = PreferencesViewController()
        controller.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    func openFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.directoryURL = FileManager.imagesURL
        if panel.runModal() == .OK{
            if let url = panel.urls.first{
                if AppData.shared.setFolderUrl(url){
                    AppData.shared.setBookmark()
                    AppData.shared.setDetailImage(nil)
                    imageGridView.updateHeaderView()
                    imageGridView.updateView()
                    detailView.detailImageDidChange()
                }
            }
        }
    }
    
}

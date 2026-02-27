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
    var sideView = SideView()
    
    var mapScrollView: MapScrollView{
        sideView.mapView.scrollView
    }
    
    var mapMenuView: MapMenuView{
        sideView.mapView.menuView
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
        sideView = SideView()
        sideView.setupView()
        let mainSplitView = HorizontalSplitView(mainView: imageGridView, sideView: sideView)
        mainSplitView.setupView()
        view.addSubviewBelow(mainSplitView, upperView: separator, insets: .zero)
            .connectToBottom(of: view, inset: .zero)
        ImageEditContext.shared.delegate = sideView
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        sideView.mapView.setDefaultLocation()
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
        sideView.mapView.refreshMap()
    }
    
    func updateMapLayersScale(){
        mapScrollView.updateItemPositions()
        mapScrollView.updateTrackPosition()
    }
    
    func zoomIn(){
        sideView.mapView.zoomIn()
        updateMapLayersScale()
    }
    
    func zoomOut(){
        sideView.mapView.zoomOut()
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
    
    func updateDetailGridItem(){
        imageGridView.updateDetailImageStatus()
    }
    
    /// menu
    
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
                    ImageEditContext.shared.setDetailImage(nil)
                    imageGridView.updateHeaderView()
                    imageGridView.updateView()
                    sideView.detailImageDidChange()
                }
            }
        }
    }
    
}

extension MainViewController: SideViewDelegate{
    
    func imageStatesChanged(){
        updateImageGrid()
    }
    
}

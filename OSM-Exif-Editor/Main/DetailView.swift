/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation


class DetailView: VerticalSplitView{
    
    var imageDetailView = ImageDetailView()
    var mapView = MapView()
    
    init(){
        super.init(topView: imageDetailView, bottomView: mapView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        imageDetailView.setupView()
        mapView.setupView()
        super.setupView()
    }
    
    func detailImageDidChange(){
        imageDetailView.detailImageDidChange()
        if let coordinate = AppData.shared.detailImage?.coordinate, coordinate != .zero{
            mapView.showLocationOnMap(coordinate: coordinate)
        }
    }
    
    func detailImagesDidChangeByTrack(){
        imageDetailView.detailImageDidChange()
        mapView.scrollView.updateItemLayerContent()
    }
    
}
    

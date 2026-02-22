/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation


class DetailView: VerticalSplitView{
    
    var image: ImageItem? = nil
    
    var imageDetailView = ImageDetailView()
    var mapView = MapView()
    
    init(){
        super.init(topView: imageDetailView, bottomView: mapView)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        imageDetailView.setupView()
        mapView.setupView()
        super.setupView()
    }
    
    func setImage(_ image: ImageItem?){
        self.image = image
        imageDetailView.setImage(image)
        if let coordinate = image?.coordinate, coordinate != .zero{
            mapView.showLocationOnMap(coordinate: coordinate)
        }
    }
    
}
    

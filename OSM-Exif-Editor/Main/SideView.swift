/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation

protocol SideViewDelegate{
    func imageStatesChanged()
}

class SideView: VerticalSplitView{
    
    var sideTopView = SideTopView()
    var mapView = MapView()
    
    var detailImage: ImageData?{
        ImageEditContext.shared.detailImage
    }
    
    init(){
        super.init(topView: sideTopView, bottomView: mapView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        topView.setupView()
        mapView.setupView()
        super.setupView()
        sideTopView.trackView.delegate = self
    }
    
    func detailImageDidChange(){
        sideTopView.detailImageDidChange()
        if let coordinate = detailImage?.coordinate, coordinate != .zero{
            ImageEditContext.shared.setImageTimeZone()
            mapView.showLocationOnMap(coordinate: coordinate)
        }
    }
    
    func detailImagesDidChangeByTrack(){
        sideTopView.detailImageDidChange()
        mapView.scrollView.updateItemLayerContent()
    }
    
}

extension SideView: EditContextDelegate{
    
    func imageChanged(){
        sideTopView.setImageView(.details)
        if let coordinate = ImageEditContext.shared.detailImage?.coordinate{
            mapView.showLocationOnMap(coordinate: coordinate)
        }
    }
    
    func trackChanged(){
        sideTopView.setImageView(.track)
        mapView.showTrackOnMap()
    }
    
    func imageTimeZoneChanged(){
        sideTopView.detailView.updateTimeZone()
    }
    
    func trackTimeZoneChanged(){
        sideTopView.trackView.updateTimeZone()
    }
}

extension SideView: TrackViewDelegate{
    
    func showTrackOnMap() {
        mapView.showTrackOnMap()
    }
    
}

    

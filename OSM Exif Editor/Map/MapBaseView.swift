//
//  MapView.swift
//  SwiftUIMapView
//
//  Created by Michael Rönnau on 12.03.25.
//

import Foundation
import SwiftUI
import CoreLocation

protocol MapBaseViewDelegate{
    func scaleChanged(to scale: CGFloat)
    func centerChanged(to coordinate: CLLocationCoordinate2D)
}

#if os(macOS)
import AppKit

struct MapBaseView: NSViewRepresentable {
    
    @State var mapStatus = MapStatus.shared
    
    func makeNSView(context: Context) -> NSMapBaseView {
        debugPrint("make")
        context.coordinator.setupView()
        return context.coordinator.mapView
    }

    func updateNSView(_ nsView: NSMapBaseView, context: Context) {
        //debugPrint("update")
        if context.coordinator.zoom != mapStatus.zoom{
            debugPrint("updating zoom")
            context.coordinator.zoomTo(mapStatus.zoom)
        }
        if context.coordinator.centerCoordinate != mapStatus.centerCoordinate{
            debugPrint("updating coordinate")
            context.coordinator.scrollTo(mapStatus.centerCoordinate)
        }
    }
    
    func makeCoordinator() -> MapBaseViewCoordinator {
        debugPrint("make coordinator")
        let coordinator = MapBaseViewCoordinator()
        coordinator.setupView()
        return coordinator
    }
    
}


#elseif os(iOS)

import UIKit

struct MapBaseView: UIViewRepresentable {
    
    @State var mapStatus = MapStatus.shared
    
    func makeUIView(context: Context) -> UIMapBaseView {
        debugPrint("make view")
        context.coordinator.setupView()
        return context.coordinator.mapView
    }

    func updateUIView(_ uiView: UIMapBaseView, context: Context) {
        //debugPrint("update")
        if context.coordinator.zoom != mapStatus.zoom{
            debugPrint("updating zoom")
            context.coordinator.zoomTo(mapStatus.zoom)
        }
        if context.coordinator.centerCoordinate != mapStatus.centerCoordinate{
            debugPrint("updating coordinate")
            context.coordinator.scrollTo(mapStatus.centerCoordinate)
        }
    }
    
    func makeCoordinator() -> MapBaseViewCoordinator {
        debugPrint("make coordinator")
        let coordinator = MapBaseViewCoordinator()
        coordinator.setupView()
        return coordinator
    }
    
}

#endif

class MapBaseViewCoordinator: NSObject, MapBaseViewDelegate{
    
#if os(macOS)
    var mapView = NSMapBaseView()
#elseif os(iOS)
    var mapView = UIMapBaseView()
#endif
    
    var zoom: Int?{
        mapView.zoom
    }
    
    var centerCoordinate: CLLocationCoordinate2D{
        mapView.centerCoordinate
    }
    
    var viewFrame: CGRect{
        mapView.frame
    }
    
    func setupView(){
        mapView.setup()
        mapView.mapViewDelegate = self
    }
    
    func zoomTo(_ zoom: Int){
        mapView.zoomTo(zoom)
    }
    
    func scrollTo(_ coordinate: CLLocationCoordinate2D){
        mapView.scrollTo(coordinate)
    }
    
    func clearTiles(){
        mapView.clearTiles()
    }
    
    func scaleChanged(to scale: CGFloat) {
        if scale != MapStatus.shared.scale{
            //debugPrint("scale changed to \(scale)")
            MapStatus.shared.scale = scale
            let zoom = World.maxZoom - World.zoomLevelFromScale(scale: 1.0/scale)
            if zoom != MapStatus.shared.zoom{
                MapStatus.shared.zoom = zoom
            }
        }
    }
    
    func centerChanged(to coordinate: CLLocationCoordinate2D) {
        if coordinate != MapStatus.shared.centerCoordinate{
            //debugPrint("center coordinate changed to \(coordinate)")
            MapStatus.shared.centerCoordinate = coordinate
        }
    }
    
}

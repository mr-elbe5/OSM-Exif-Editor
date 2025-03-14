/*
 E5MapData
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

struct World{
    
    static var maxZoom : Int = 18
    static var minZoom : Int = 4
    static let tileExtent : Double = 256.0
    static let tileSize : CGSize = CGSize(width: tileExtent, height: tileExtent)
    static var fullExtent = pow(2,Double(maxZoom))*tileExtent
    static let equatorInMeters : CGFloat = 40075016.686
    static var worldSize = CGSize(width: fullExtent, height: fullExtent)
    static var worldRect = CGRect(origin: CGPoint(x: 0, y: 0), size: worldSize)
    static var scrollWidthFactor : CGFloat = 3
    static var scrollableWorldSize = CGSize(width: scrollWidthFactor*fullExtent, height: fullExtent)
    
    static func setMaxZoom(_ maxZoom: Int){
        World.maxZoom = maxZoom
        World.fullExtent = pow(2,Double(World.maxZoom))*tileExtent
        World.worldSize = CGSize(width: World.fullExtent, height: World.fullExtent)
        World.worldRect = CGRect(origin: CGPoint(x: 0, y: 0), size: World.worldSize)
        World.scrollableWorldSize = CGSize(width: World.scrollWidthFactor*World.fullExtent, height: World.fullExtent)
    }
    
    static func zoomScale(at zoom: Int) -> Double{
        pow(2.0, CGFloat(zoom))
    }
    
    static func zoomScale(from: Int, to: Int) -> Double{
        zoomScale(at: to - from)
    }
    
    static func zoomScaleToWorld(from zoom: Int) -> Double{
        zoomScale(from: zoom, to: maxZoom)
    }
    
    static func zoomScaleFromWorld(to zoom: Int) -> Double{
        zoomScale(from: maxZoom, to: zoom)
    }
    
    static func zoomLevelFromScale(scale: CGFloat) -> Int{
        if scale == 0{
            return maxZoom
        }
        return Int(floor(log2(scale)))
    }
    
    static func zoomedWorld(zoom: Int) -> CGRect{
        let scale = zoomScale(from: maxZoom, to: zoom)
        return CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: fullExtent*scale, height: fullExtent*scale))
    }
    
    static func scaledWorld(zoom: Int) -> CGRect{
        let scale = zoomScale(from: maxZoom, to: zoom)
        return CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: fullExtent*scale, height: fullExtent*scale))
    }
    
    static func latitudeDegreesForMeters(_ meters: CLLocationDistance) -> CLLocationDegrees{
        meters/equatorInMeters*360
    }
    
    static func longitudeDegreesForMetersAtLatitude(_ meters: CLLocationDistance, lat: CLLocationDegrees) -> CLLocationDegrees{
        meters/equatorInMeters*360*cos(lat)
    }
    
    static func metersPerMapPointAtLatitude(_ lat: CLLocationDegrees) -> CLLocationDistance{
        equatorInMeters/tileExtent*cos(lat)
    }
    
    static func mapPointsPerMeterAtLatitude(_ lat: CLLocationDegrees) -> Double{
        1/metersPerMapPointAtLatitude(lat)
    }
    
    static func projectedLongitude(_ longitude: Double) -> Double {
        (longitude + 180)/360.0
    }
    
    static func projectedLatitude(_ latitude: Double) -> Double {
        (1 - log( tan(latitude * Double.pi/180.0 ) + 1/cos(latitude * Double.pi / 180.0 ))/Double.pi)/2
    }
    
    static func tileX(_ longitude: Double) -> Int {
        Int(floor(projectedLongitude(longitude)))
    }
    
    static func tileX(_ longitude: Double, at zoom: Int) -> Int {
        Int(floor(projectedLongitude(longitude)*pow(2.0, Double(zoom))))
    }
    
    static func tileY(_ latitude: Double) -> Int {
        Int(floor(projectedLatitude(latitude)))
    }
    
    static func tileY(_ latitude: Double, at zoom: Int) -> Int {
        Int(floor(projectedLatitude(latitude)*pow(2.0, Double(zoom))))
    }
    
    static func worldX(_ longitude: Double) -> Double {
        round(projectedLongitude(longitude)*World.fullExtent)
    }
    
    static func worldY(_ latitude: Double) -> Double {
        round(projectedLatitude(latitude)*World.fullExtent)
    }
    
    static func worldPoint(coordinate: CLLocationCoordinate2D) -> CGPoint {
        CGPoint(x: worldX(coordinate.longitude),
                y: worldY(coordinate.latitude))
    }
    
    static func coordinate(worldX : Double, worldY : Double) -> CLLocationCoordinate2D {
        let lon = worldX/World.fullExtent*360.0 - 180.0
        let lat = atan( sinh (Double.pi - (worldY/World.fullExtent)*2*Double.pi)) * (180.0/Double.pi)
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    static func mapPoint(scaledX : Double, scaledY : Double, downScale: Double) -> CGPoint{
        if downScale == 0{
            return CGPoint()
        }
        return CGPoint(x: scaledX/downScale, y: scaledY / downScale)
    }
    
    static func mapPoint(scaledPoint: CGPoint, downScale: Double) -> CGPoint{
        mapPoint(scaledX: scaledPoint.x, scaledY: scaledPoint.y, downScale: downScale)
    }
    
    static func worldRect(scaledX : Double, scaledY : Double, scaledWidth: Double, scaledHeight: Double, downScale: Double) -> CGRect{
        if downScale == 0{
            return CGRect()
        }
        return CGRect(origin: CGPoint(x: scaledX/downScale, y: scaledY/downScale), size: CGSize(width: scaledWidth/downScale, height: scaledHeight/downScale))
    }
    
    static func worldRect(scaledRect: CGRect, at zoom: Int) -> CGRect{
        worldRect(scaledRect: scaledRect, downScale: zoomScaleFromWorld(to: zoom))
    }
    
    static func worldRect(scaledRect: CGRect, downScale: Double) -> CGRect{
        worldRect(scaledX: scaledRect.origin.x, scaledY: scaledRect.origin.y, scaledWidth: scaledRect.size.width, scaledHeight: scaledRect.size.height, downScale: downScale)
    }
    
    static func coordinate(scaledX : Double, scaledY : Double, at zoom: Int) -> CLLocationCoordinate2D {
        coordinate(scaledX: scaledX, scaledY: scaledY, downScale: zoomScaleFromWorld(to: zoom))
    }
    
    static func coordinate(scaledX : Double, scaledY : Double, downScale: Double) -> CLLocationCoordinate2D {
        let mapPoint = mapPoint(scaledX: scaledX, scaledY: scaledY, downScale: downScale).normalizedPoint
        return mapPoint.coordinate
    }
    
    static func scaledExtent(downScale: Double) -> Double {
        fullExtent*downScale
    }
    
    static func scaledX(_ longitude: Double, downScale: Double) -> Double {
        round(projectedLongitude(longitude)*fullExtent*downScale)
    }
    
    static func scaledY(_ latitude: Double, downScale: Double) -> Double {
        round(projectedLatitude(latitude)*fullExtent*downScale)
    }
    
    static func zoomedPoint(coordinate: CLLocationCoordinate2D, zoom: Int) -> CGPoint {
        CGPoint(x: round(projectedLongitude(coordinate.longitude)*fullExtent*zoomScale(at: zoom - maxZoom)),
                y: round(projectedLatitude(coordinate.latitude)*fullExtent*zoomScale(at: zoom - maxZoom)))
    }
    
    static func getZoomToFit(worldRect: CGRect, scaledSize: CGSize) -> Int{
        if worldRect.size.height == 0{
            return maxZoom
        }
        let scaleDiff = min(scaledSize.width/worldRect.size.width, scaledSize.height/worldRect.size.height)
        return World.maxZoom + min(0, zoomLevelFromScale(scale: scaleDiff))
    }
    
    static func offset(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, at zoom: Int) -> CGSize{
        let fromPoint = zoomedPoint(coordinate: from, zoom: zoom)
        let toPoint = zoomedPoint(coordinate: to, zoom: zoom)
        return CGSize(width: toPoint.x - fromPoint.x, height: toPoint.y - fromPoint.y)
    }
    
}

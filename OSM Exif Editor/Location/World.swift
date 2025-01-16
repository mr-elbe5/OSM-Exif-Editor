/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

struct World{
    
    static var maxZoom : Int = 18
    static var minZoom : Int = 4
    static let tileExtent : Double = 256.0
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
    
    static func downScale(to zoom: Int) -> Double{
        zoomScale(at: zoom - maxZoom)
    }
    
    static func upScale(from zoom: Int) -> Double{
        zoomScale(at: maxZoom - zoom)
    }
    
    static func zoomLevelFromScale(scale: CGFloat) -> Int{
        if scale == 0{
            return maxZoom
        }
        return Int(floor(log2(scale)))
    }
    
    static func zoomedWorld(zoom: Int) -> CGRect{
        let scale = downScale(to: zoom)
        return CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: fullExtent*scale, height: fullExtent*scale))
    }
    
    static func scaledWorld(zoom: Int) -> CGRect{
        let scale = downScale(to: zoom)
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
    
    private static func projectedLongitude(_ longitude: Double) -> Double {
        (longitude + 180)/360.0
    }
    
    private static func projectedLatitude(_ latitude: Double) -> Double {
        (1 - log( tan(latitude * Double.pi/180.0 ) + 1/cos(latitude * Double.pi / 180.0 ))/Double.pi)/2
    }
    
    static func tilePoint(coordinate: CLLocationCoordinate2D, at zoom: Int) -> IntPoint {
        IntPoint(x: Int(floor(projectedLongitude(coordinate.longitude)*pow(2.0, Double(zoom)))),
                     y: Int(floor(projectedLatitude(coordinate.latitude)*pow(2.0, Double(zoom)))))
    }
    
    static func coordinate(scaledPoint: CGPoint, at zoom: Int) -> CLLocationCoordinate2D {
        let scale = downScale(to: zoom)
        var worldPoint = CGPoint(x: scaledPoint.x/scale, y: scaledPoint.y / scale)
        if worldPoint.x > World.worldSize.width{
            worldPoint = CGPoint(x: worldPoint.x - World.worldSize.width, y: worldPoint.y)
        }
        return coordinate(worldPoint)
    }
    
    static func coordinate(_ worldPoint: CGPoint) -> CLLocationCoordinate2D{
        let longitude = worldPoint.x/World.fullExtent*360.0 - 180.0
        let latitude = atan(sinh(CGFloat.pi - (worldPoint.y/World.fullExtent)*2*CGFloat.pi))*(180.0/CGFloat.pi)
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func zoomedPoint(coordinate: CLLocationCoordinate2D, zoom: Int) -> CGPoint {
        CGPoint(x: round(projectedLongitude(coordinate.longitude)*fullExtent*zoomScale(at: zoom - maxZoom)),
                y: round(projectedLatitude(coordinate.latitude)*fullExtent*zoomScale(at: zoom - maxZoom)))
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
    
    static func worldRect(scaledX : Double, scaledY : Double, scaledWidth: Double, scaledHeight: Double, at zoom: Int) -> CGRect{
        let downScale = downScale(to: zoom)
        if downScale == 0{
            return CGRect()
        }
        return CGRect(origin: CGPoint(x: scaledX/downScale, y: scaledY/downScale), size: CGSize(width: scaledWidth/downScale, height: scaledHeight/downScale))
    }
    
    static func worldRect(scaledRect: CGRect, at zoom: Int) -> CGRect{
        worldRect(scaledX: scaledRect.origin.x, scaledY: scaledRect.origin.y, scaledWidth: scaledRect.size.width, scaledHeight: scaledRect.size.height, at: zoom)
    }
    
    static func offset(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, at zoom: Int) -> CGSize{
        let fromPoint = zoomedPoint(coordinate: from, zoom: zoom)
        let toPoint = zoomedPoint(coordinate: to, zoom: zoom)
        return CGSize(width: toPoint.x - fromPoint.x, height: toPoint.y - fromPoint.y)
    }
    
    static func getZoomToFit(worldRect: CGRect, scaledSize: CGSize) -> Int{
        if worldRect.size.height == 0{
            return maxZoom
        }
        let scaleDiff = min(scaledSize.width/worldRect.size.width, scaledSize.height/worldRect.size.height)
        return World.maxZoom + min(0, zoomLevelFromScale(scale: scaleDiff))
    }
    
}

/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

@Observable class MapStatus: Identifiable, Codable{
    
    static var storeKey = "mapstatus"
    
    static var shared = MapStatus()
    
    static func load(){
        if let status : MapStatus = StatusManager.shared.getCodable(key: MapStatus.storeKey){
            MapStatus.shared = status
        }
        else{
            debugPrint("no saved data available for map status")
            MapStatus.shared = MapStatus()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case zoom
        case scale
        case latitude
        case longitude
    }
    
    private var _centerCoordinate: CLLocationCoordinate2D
    
    var zoom = World.minZoom
    var scale = 1.0
    var centerCoordinate: CLLocationCoordinate2D{
        get{
            _centerCoordinate
        }
        set{
            _centerCoordinate = newValue
        }
    }
    
    var bounds: CGRect = .zero
    
    var scaledWorldCenterPoint: CGPoint{
        World.zoomedPoint(coordinate: centerCoordinate, zoom: zoom)
    }

    init(){
        _centerCoordinate = MapDefaults.startCoordinate
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        zoom = try values.decodeIfPresent(Int.self, forKey: .zoom) ?? MapDefaults.startZoom
        scale = try values.decodeIfPresent(Double.self, forKey: .scale) ?? 1.0
        let latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        let longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        if let latitude = latitude, let longitude = longitude{
            _centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        else {
            _centerCoordinate = MapDefaults.startCoordinate
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(zoom, forKey: .zoom)
        try container.encode(scale, forKey: .scale)
        try container.encode(centerCoordinate.latitude, forKey: .latitude)
        try container.encode(centerCoordinate.longitude, forKey: .longitude)
    }
    
    func zoomIn(){
        if zoom < World.maxZoom{
            zoom += 1
        }
    }
    
    func zoomOut(){
        if zoom > World.minZoom{
            zoom -= 1
        }
    }
    
    func save(){
        StatusManager.shared.saveCodable(key: MapStatus.storeKey, value: self)
    }
    
}


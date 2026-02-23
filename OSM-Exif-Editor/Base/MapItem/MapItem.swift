/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

class MapItem: Mappoint, Identifiable, Hashable {
    
    static func == (lhs: MapItem, rhs: MapItem) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    
    init(){
        id = UUID()
        super.init(coordinate: .zero)
    }
    
    init(coordinate: CLLocationCoordinate2D){
        id = UUID()
        super.init(coordinate: coordinate)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

typealias MapItemList = MappointList<MapItem>


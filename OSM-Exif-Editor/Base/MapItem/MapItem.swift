/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import CloudKit

class MapItem: LocationData, Identifiable, Hashable {
    
    static var recordType: CKRecord.RecordType = "item"
    
    static var mergeDistance: CGFloat = 10
    
    static func == (lhs: MapItem, rhs: MapItem) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var creationDate: Date
    var changeDate: Date
    
    var itemType: String{
        get{
            ""
        }
    }
    
    override init(){
        id = UUID()
        let date = Date()
        creationDate = date
        changeDate = date
        super.init()
    }
    
    override init(coordinate: CLLocationCoordinate2D){
        id = UUID()
        let date = Date()
        creationDate = date
        changeDate = date
        super.init(coordinate: coordinate)
    }
    
    func setModified(){
        changeDate = Date().rounded()
    }
    
    func prepareToDelete(){        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

typealias MapItemList = LocationList<MapItem>

extension MapItemList{
    
    mutating func sortByDate(ascending: Bool){
        if ascending{
            self.sort(by: { $0.creationDate < $1.creationDate})
        }
        else{
            self.sort(by: { $0.creationDate > $1.creationDate})
        }
    }
    
}

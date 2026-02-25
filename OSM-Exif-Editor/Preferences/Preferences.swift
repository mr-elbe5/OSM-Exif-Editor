/*
 OSM Maps (Mac)
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class Preferences: Identifiable, Codable{
    
    static var storeKey = "preferences"
    
    static var shared = Preferences()
    
    static func load(){
        if let prefs : Preferences = StatusManager.shared.getCodable(key: Preferences.storeKey){
            Preferences.shared = prefs
        }
        else{
            Log.error("no saved data available for preferences")
            Preferences.shared = Preferences()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case mapSource
        case gridSizeFactorIndex
    }
    
    var mapSource : MapSource = .osm
    var gridSizeFactorIndex: Int = 1
    
    init(){
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let mapSourceString = try? values.decodeIfPresent(String.self, forKey: .mapSource){
            mapSource = MapSource(rawValue: mapSourceString) ?? .osm
        }
        gridSizeFactorIndex = try values.decodeIfPresent(Int.self, forKey: .gridSizeFactorIndex) ?? 1
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mapSource.rawValue, forKey: .mapSource)
        try container.encode(gridSizeFactorIndex, forKey: .gridSizeFactorIndex)
    }
    
    func save(){
        StatusManager.shared.saveCodable(key: Preferences.storeKey, value: self)
        Log.debug("Preferences saved")
    }
    
}



/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

@Observable class Preferences: Identifiable, Codable{
    
    static var storeKey = "preferences"
    
    static var shared = Preferences()
    
    static func load(){
        if let prefs : Preferences = StatusManager.shared.getCodable(key: Preferences.storeKey){
            Preferences.shared = prefs
        }
        else{
            debugPrint("no saved data available for preferences")
            Preferences.shared = Preferences()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case urlTemplate
        case followTrack
        case trackpointInterval
        case maxHorizontalUncertainty
        case maxSpeedUncertaintyFactor
        case minHorizontalTrackpointDistance
        case maxSearchResults
        case maxLocationMergeDistance
    }
    
    var urlTemplate : String = MapDefaults.elbe5Url
    var followTrack : Bool = false
    var showTrackpoints : Bool = false
    
    var trackpointInterval: Double = MapDefaults.defaultTrackpointInterval
    var maxHorizontalUncertainty: Double = MapDefaults.defaultMaxHorizontalUncertainty
    var minHorizontalTrackpointDistance = MapDefaults.defaultMinHorizontalTrackpointDistance
    var maxSearchResults = MapDefaults.defaultMaxSearchResults
    var maxLocationMergeDistance: Double = MapDefaults.defaultMaxLocationMergeDistance
    
    init(){
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        urlTemplate = try values.decodeIfPresent(String.self, forKey: .urlTemplate) ?? MapDefaults.osmUrl
        followTrack = try values.decodeIfPresent(Bool.self, forKey: .followTrack) ?? false
        trackpointInterval = try values.decodeIfPresent(Double.self, forKey: .trackpointInterval) ?? MapDefaults.defaultTrackpointInterval
        maxHorizontalUncertainty = try values.decodeIfPresent(Double.self, forKey: .maxHorizontalUncertainty) ?? MapDefaults.defaultMaxHorizontalUncertainty
        minHorizontalTrackpointDistance = try values.decodeIfPresent(Double.self, forKey: .minHorizontalTrackpointDistance) ?? MapDefaults.defaultMinHorizontalTrackpointDistance
        maxSearchResults = try values.decodeIfPresent(Int.self, forKey: .maxSearchResults) ?? MapDefaults.defaultMaxSearchResults
        maxLocationMergeDistance = try values.decodeIfPresent(Double.self, forKey: .maxLocationMergeDistance) ?? MapDefaults.defaultMaxLocationMergeDistance
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(urlTemplate, forKey: .urlTemplate)
        try container.encode(followTrack, forKey: .followTrack)
        try container.encode(maxHorizontalUncertainty, forKey: .maxHorizontalUncertainty)
        try container.encode(minHorizontalTrackpointDistance, forKey: .minHorizontalTrackpointDistance)
        try container.encode(maxSearchResults, forKey: .maxSearchResults)
        try container.encode(maxLocationMergeDistance, forKey: .maxLocationMergeDistance)
    }
    
    func save(){
        StatusManager.shared.saveCodable(key: Preferences.storeKey, value: self)
    }
    
}


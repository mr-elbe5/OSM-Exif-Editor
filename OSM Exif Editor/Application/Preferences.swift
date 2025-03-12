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
            Preferences.shared.urlTemplate = prefs.urlTemplate
            Preferences.shared.showTwoColumns = prefs.showTwoColumns
        }
        else{
            debugPrint("no saved data available for preferences")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case urlTemplate
        case maxSearchResults
        case showTwoColumns
    }
    
    var urlTemplate : String = MapDefaults.elbe5Url
    var elevationUrl: String = MapDefaults.elbe5ElevationUrl
    var showTwoColumns: Bool = false
    
    var maxSearchResults = MapDefaults.defaultMaxSearchResults
    
    init(){
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        urlTemplate = try values.decodeIfPresent(String.self, forKey: .urlTemplate) ?? MapDefaults.elbe5Url
        showTwoColumns = try values.decodeIfPresent(Bool.self, forKey: .showTwoColumns) ?? false
        maxSearchResults = try values.decodeIfPresent(Int.self, forKey: .maxSearchResults) ?? MapDefaults.defaultMaxSearchResults
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(urlTemplate, forKey: .urlTemplate)
        try container.encode(showTwoColumns, forKey: .showTwoColumns)
        try container.encode(maxSearchResults, forKey: .maxSearchResults)
    }
    
    func save(){
        StatusManager.shared.saveCodable(key: Preferences.storeKey, value: self)
    }
    
}


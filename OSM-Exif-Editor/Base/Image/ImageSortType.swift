/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Foundation

enum ImageSortType: String, Codable, CaseIterable{
    
    case byName
    case byExtension
    case byExifCreation
    case byFileCreation
    case byFileModification
    case byLatitude
    case byLongitude
    case byAltitude
    
    var localizedName: String {
        self.rawValue.localize()
    }
    
    static func index(of type: ImageSortType) -> Int{
        for (index, sortType) in ImageSortType.allCases.enumerated() {
            if sortType == type {
                return index
            }
        }
        return 0
    }
    
}

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
    
}

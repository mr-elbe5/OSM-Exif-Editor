/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation

typealias ImageList = [ImageData]

extension ImageList{
    
    var allSelected: Bool{
        get{
            allSatisfy({
                $0.selected
            })
        }
    }
    
    var allUnselected: Bool{
        get{
            allSatisfy({
                !$0.selected
            })
        }
    }
    
    var anySelected: Bool{
        get{
            !allUnselected
        }
    }
    
    mutating func selectAll(){
        for image in self{
            image.selected = true
        }
    }
    
    mutating func deselectAll(){
        for image in self{
            image.selected = false
        }
    }
    
    mutating func toggleSelection(){
        var selected = false
        for image in self{
            if image.selected{
                selected = true
                break
            }
        }
        for image in self{
            image.selected = !selected
        }
    }
    
    func findNearestImage(to coordinate: CLLocationCoordinate2D) -> (ImageData, Double)? {
        var nearestImage: ImageData?
        var minDistance: Double?
        for image in self {
            if let distance = image.coordinate?.distance(to: coordinate){
                if minDistance == nil || distance < minDistance! {
                    nearestImage = image
                    minDistance = distance
                }
            }
        }
        if let image = nearestImage, let dist = minDistance {
            return (image, dist)
        }
        return nil
    }
    
    func findClosestImage(to date: Date) -> (ImageData, TimeInterval)?{
        var closestImage: ImageData?
        var minTimeDiff: TimeInterval?
        for image in self {
            if let timestamp = image.creationDate {
                let diff = abs(timestamp.distance(to: date))
                if minTimeDiff == nil || diff < minTimeDiff! {
                    closestImage = image
                    minTimeDiff = diff
                }
            }
            
        }
        if let image = closestImage, let diff = minTimeDiff {
            return (image, diff)
        }
        return nil
    }
    
}

extension ImageList{
    
    mutating func sort(by sortType: ImageSortType, ascending: Bool){
        switch sortType{
        case .byName:
            self.sort(by: { $0.url.lastPathComponent < $1.url.lastPathComponent})
        case .byExtension:
            self.sort(by: { $0.url.pathExtension.lowercased() < $1.url.pathExtension.lowercased()})
        case .byExifCreation:
            self.sort(by: {
                if let dateLeft = $0.exifCreationDate{
                    if let dateRight = $1.exifCreationDate{
                        return dateLeft < dateRight
                    }
                    return false
                }
                return true
            })
        case .byFileCreation:
            self.sort(by: {
                if let dateLeft = $0.fileCreationDate{
                    if let dateRight = $1.fileCreationDate{
                        return dateLeft < dateRight
                    }
                    return false
                }
                return true
            })
            
        case .byFileModification:
            self.sort(by: {
                if let dateLeft = $0.fileModificationDate{
                    if let dateRight = $1.fileModificationDate{
                        return dateLeft < dateRight
                    }
                    return false
                }
                return true
            })
        case .byLatitude:
            self.sort(by: {
                if let latitudeLeft = $0.exifLatitude{
                    if let latitudeRight = $1.exifLatitude{
                        return latitudeLeft < latitudeRight
                    }
                    return false
                }
                return true
            })
        case .byLongitude:
            self.sort(by: {
                if let longitudeLeft = $0.exifLongitude{
                    if let longitudeRight = $1.exifLongitude{
                        return longitudeLeft < longitudeRight
                    }
                    return false
                }
                return true
            })
        case .byAltitude:
            self.sort(by: {
                if let altitudeLeft = $0.exifAltitude{
                    if let altitudeRight = $1.exifAltitude{
                        return altitudeLeft < altitudeRight
                    }
                    return false
                }
                return true
            })
        }
        if !ascending{
            self.reverse()
        }
    }
    
}

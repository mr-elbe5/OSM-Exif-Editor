/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation
import UniformTypeIdentifiers

protocol EditContextDelegate{
    func imageChanged()
    func trackChanged()
    func imageTimeZoneChanged()
    func trackTimeZoneChanged()
}

class ImageEditContext{
    
    static var shared = ImageEditContext()
    
    var detailImage: ImageData? = nil
    var imageTimeZone: TimeZone = .current
    var track: Track? = nil
    var trackTimeZone: TimeZone = .current
    var trackUTCOffset: Int = 0
    
    var delegate: EditContextDelegate? = nil
    
    func setDetailImage(_ image: ImageData?){
        self.detailImage = image
        setImageTimeZone()
        delegate?.imageChanged()
    }
    
    func setImageTimeZone(completed: (()->())? = nil){
        imageTimeZone = .current
        if let coordinate = detailImage?.coordinate{
            TimeZone.getTimeZoneAsync(coordinate: coordinate){ result in
                self.imageTimeZone = result
                Log.info("image timezone is \(result.identifier)")
                self.delegate?.imageTimeZoneChanged()
                completed?()
            }
        }
    }
    
    func setTrack(_ track: Track?){
        self.track = track
        delegate?.trackChanged()
    }
    
    func setTrackTimeZone(completed: (()->())? = nil){
        trackTimeZone = .current
        if let coordinate = track?.startCoordinate{
            TimeZone.getTimeZoneAsync(coordinate: coordinate){ result in
                self.trackTimeZone = result
                if let track = self.track{
                    self.trackUTCOffset = UTCOffset(timeZone: self.trackTimeZone, for: track.startTime).value
                }
                else{
                    self.trackUTCOffset = 0
                }
                Log.info("track timezone is \(result.identifier)")
                Log.info("track utc offset is \(self.trackUTCOffset)")
                self.delegate?.trackTimeZoneChanged()
                completed?()
            }
        }
    }
    
    func selectImagesWithCloseCreationDate() -> Bool{
        var hasResult = false
        if let track = track{
            AppData.shared.images.deselectAll()
            for image in AppData.shared.images{
                if let date = image.creationDate, let result = track.findClosestTrackpoint(at: date, maxSecDiff: 10){
                    if image.coordinate == nil{
                        image.exifLatitude = result.0.coordinate.latitude
                        image.exifLongitude = result.0.coordinate.longitude
                        image.exifAltitude = result.0.altitude
                        image.isModified = true
                    }
                    image.selected = true
                    hasResult = true
                }
            }
        }
        return hasResult
    }
    
    func getImagesOfTrackByDistance(track: Track, maxDistance: Double = 20) -> ImageList{
        var list = ImageList()
        for image in AppData.shared.images{
            if let coordinate = image.coordinate{
                if let result = track.trackpoints.findNearestPoint(to: coordinate){
                    let distance = result.1
                    if distance < maxDistance{
                        list.append(image)
                    }
                }
            }
        }
        return list
    }
    
    func getImagesOfTrackByTime(track: Track) -> ImageList{
        var list = ImageList()
        let startDate = track.startTime
        let endDate = track.endTime
        for image in AppData.shared.images{
            if let date = image.creationDate, date >= startDate && date <= endDate{
                list.append(image)
            }
        }
        return list
    }
    
}

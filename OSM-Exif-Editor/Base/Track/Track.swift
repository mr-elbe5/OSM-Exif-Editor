/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import CloudKit

class Track: NSObject{
    
    static func loadFromFile(gpxUrl: URL) -> Track?{
        if let data = FileManager.default.readFile(url: gpxUrl){
            let parser = XMLParser(data: data)
            let track = Track()
            parser.delegate = track
            guard parser.parse() else { return nil }
            return track
        }
        return nil
    }
    
    static var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .short
        formatter.maximumUnitCount = 2
        formatter.collapsesLargestUnit = false
        formatter.zeroFormattingBehavior = .default
        return formatter
    }()
        
    private enum CodingKeys: String, CodingKey {
        case name
        case trackpoints
        case startTime
        case endTime
        case distance
        case upDistance
        case downDistance
        case coordinateRegion
        case centerCoordinateLatitude
        case centerCoordinateLongitude
    }
    
    var name : String
    var trackpoints: TrackpointList
    var pauseTime : Date? = nil
    var pauseLength : TimeInterval = 0
    var distance : CGFloat
    var upDistance : CGFloat
    var downDistance : CGFloat
    var coordinateRegion : CoordinateRegion? = nil
    var centerCoordinate : CLLocationCoordinate2D? = nil
    
    var currentTag: String? = nil
    var currentPoint: Trackpoint? = nil
    
    var worldRect: CGRect?{
        coordinateRegion?.worldRect
    }
    
    var startTime : Date{
        trackpoints.first?.timestamp ?? Date()
    }
    var endTime :Date{
        trackpoints.last?.timestamp ?? Date()
    }
    
    var durationString: String{
        return Self.durationFormatter.string(from: duration) ?? "00:00"
    }
    
    var duration : TimeInterval{
        if let pauseTime = pauseTime{
            return startTime.distance(to: pauseTime) - pauseLength
        }
        return startTime.distance(to: endTime) - pauseLength
    }
    
    var durationUntilNow : TimeInterval{
        if let pauseTime = pauseTime{
            return startTime.distance(to: pauseTime) - pauseLength
        }
        return startTime.distance(to: Date.localDate) - pauseLength
    }
    
    var startCoordinate: CLLocationCoordinate2D?{
        trackpoints.first?.coordinate
    }
    
    var endCoordinate: CLLocationCoordinate2D?{
        trackpoints.last?.coordinate
    }
    
    override init(){
        name = "Tour"
        trackpoints = TrackpointList()
        distance = 0
        upDistance = 0
        downDistance = 0
        super.init()
    }
    
    func update(from track: Track){
        trackpoints.removeAll()
        trackpoints.append(contentsOf: track.trackpoints)
        updateFromTrackpoints()
    }
    
    func setNameByDate(){
        name = "tourOf".localize(s: startTime.dateTimeString())
    }
    
    func pauseTracking(){
        pauseTime = Date.localDate
    }
    
    func resumeTracking(){
        if let pauseTime = pauseTime{
            pauseLength += pauseTime.distance(to: Date.localDate)
            self.pauseTime = nil
        }
    }
    
    func addTrackpoint(_ tp: Trackpoint){
        trackpoints.append(tp)
        updateFromTrackpoints()
    }
    
    func insertTrackpoint(_ tp: Trackpoint, at index: Int){
        if index < 0 || index >= trackpoints.count - 1{
            return
        }
        trackpoints.insert(tp, at: index)
        updateFromTrackpoints()
    }
    
    func setTrackpoints(_ trackpoints: TrackpointList){
        if !trackpoints.isEmpty{
            self.trackpoints = trackpoints
            updateFromTrackpoints()
        }
    }
    
    func updateFromTrackpoints(){
        if !trackpoints.isEmpty{
            distance = 0
            upDistance = 0
            downDistance = 0
            var last : Trackpoint? = nil
            for tp in trackpoints{
                if let last = last{
                    distance += last.coordinate.distance(to: tp.coordinate)
                    if let tpAlt = tp.altitude, let lastAlt = last.altitude{
                        let verticalDiff = tpAlt - lastAlt
                        if verticalDiff > 0{
                            upDistance += verticalDiff
                        }
                        else{
                            downDistance += abs(verticalDiff)
                        }
                    }
                }
                last = tp
            }
            updateCoordinateRegion()
        }
    }
    
    func setMinimalTrackpointDistances(minDistance: CGFloat){
        if !trackpoints.isEmpty{
            var removables = TrackpointList()
            var last : Trackpoint = trackpoints.first!
            for idx in 1..<trackpoints.count - 1{
                let tp = trackpoints[idx]
                let distance = last.coordinate.distance(to: tp.coordinate)
                if distance < minDistance{
                    removables.append(tp)
                }
                else{
                    last = tp
                }
            }
            trackpoints.removeAll(where: { tp1 in
                removables.contains(where: { tp2 in
                    tp1.coordinate == tp2.coordinate
                })
            })
        }
        updateFromTrackpoints()
    }
    
    func findNearestTrackpoint(to coordinate: CLLocationCoordinate2D, maxMeterDiff: Double = 100) -> (Trackpoint, Double)? {
        var result: (Trackpoint, Double)?
        if let closests = trackpoints.findNearestPoint(to: coordinate){
            if closests.1 < (result?.1 ?? Double.greatestFiniteMagnitude){
                result = closests
            }
        }
        if let result = result, result.1 > maxMeterDiff{
            return nil
        }
        return result
    }
    
    func findClosestTrackpoint(at date: Date, maxSecDiff: Double = 60) -> (Trackpoint, TimeInterval)?{
        var result: (Trackpoint, Double)?
        if let closests = trackpoints.findClosestPoint(to: date){
            if closests.1 < (result?.1 ?? Double.greatestFiniteMagnitude){
                result = closests
            }
        }
        // distance must be less than 1h
        if let result = result, result.1 > maxSecDiff*60{
            return nil
        }
        return result
    }
    
    func updateCoordinateRegion(){
        coordinateRegion = trackpoints.coordinateRegion
        centerCoordinate = coordinateRegion?.center
    }
    
    func createGPXFile() -> URL?{
        let fileName = name.replacingOccurrences(of: " ", with: "_")
        if let url = URL(string: "track_\(fileName)_\(startTime.fileDate()).gpx", relativeTo: URL.temporaryDirectory){
            let s = gpxString()
            if let data = s.data(using: .utf8){
                return FileManager.default.saveFile(data : data, url: url) ? url : nil
            }
        }
        return nil
    }
    
    func gpxString() -> String{
        var str = """
            <?xml version='1.0' encoding='UTF-8'?>
            <gpx version="1.1" creator="OSM Maps" xmlns="http://www.topografix.com/GPX/1/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
                <metadata>
                    <name>\(name)</name>
                </metadata>
                <trk>
                    <trkseg>
            """
            for tp in trackpoints{
                str += tp.gpxString
            }
            str += """
        
                </trkseg>
            </trk>
        </gpx>
        """
        return str
    }
    
}

extension Track : XMLParserDelegate{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentTag = elementName
        switch elementName{
        case "trkpt":
            guard let latString = attributeDict["lat"], let lonString = attributeDict["lon"] else { return }
            guard let lat = Double(latString), let lon = Double(lonString) else { return }
            guard let latDegrees = CLLocationDegrees(exactly: lat), let lonDegrees = CLLocationDegrees(exactly: lon) else { return }
            currentPoint = Trackpoint(coordinate: CLLocationCoordinate2D(latitude: latDegrees, longitude: lonDegrees))
        default :
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if string.isEmpty{
            return
        }
        switch currentTag{
        case "name":
            name += string
        case "time":
            if let point = currentPoint, let timestamp = string.ISO8601Date(){
                point.timestamp = timestamp
            }
        case "ele":
            if let point = currentPoint, let dist = CLLocationDistance(string){
                point.altitude =  dist
            }
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName{
        case "trkpt":
            if let point = currentPoint{
                trackpoints.append(point)
                currentPoint = nil
            }
        default:
            break
        }
        currentTag = nil
    }
    
}


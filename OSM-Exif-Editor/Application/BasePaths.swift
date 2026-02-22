/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

struct BasePaths {
    
    static var tileDirURL = URL.cachesDirectory.appendingPathComponent("tiles")
    static var statusDirURL = URL.applicationSupportDirectory.appendingPathComponent("status")
    static var homeDirURL = URL.homeDirectory
    
    static func initializeDirs() {
        try! FileManager.default.createDirectory(at: URL.applicationSupportDirectory, withIntermediateDirectories: true, attributes: nil)
        Log.debug("base dir is: \(URL.applicationSupportDirectory.path)")
        
        try! FileManager.default.createDirectory(at: statusDirURL, withIntermediateDirectories: true, attributes: nil)
        Log.debug("status dir is: \(statusDirURL.path)")
        try! FileManager.default.createDirectory(at: tileDirURL, withIntermediateDirectories: true, attributes: nil)
        Log.debug("tile dir is: \(tileDirURL.path)")
    }
    
}

/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import AVFoundation
import CoreLocation

class ImagePicker: NSObject  {
    
    static var shared: ImagePicker?
    
    var controller: NSViewController
    var atCenter: Bool = false
    var completionHandler: (() -> Void)?
    
    init(controller: NSViewController){
        self.controller = controller
    }
    
    func addImagesFromFiles(atCenter: Bool, onCompletion: (() -> Void)? = nil) {
        self.atCenter = atCenter
        self.completionHandler = onCompletion
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.directoryURL = FileManager.imagesURL
        if panel.runModal() == .OK{
            if let url = panel.urls.first{
                
            }
        }
        Self.shared = nil
    }
    
}








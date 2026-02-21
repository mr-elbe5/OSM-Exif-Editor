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
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = [.image]
        panel.directoryURL = FileManager.imagesURL
        if panel.runModal() == .OK{
            for url in panel.urls{
                let image = ImageItem()
                if let data = FileManager.default.readFile(url: url), let img = OSImage(data: data){
                    image.originalFileName = url.lastPathComponent
                    image.generateFileName()
                    image.loadMetaData(from: data)
                    if let dateTime = image.metaData!.dateTime{
                        image.creationDate = dateTime
                    }
                    if atCenter{
                        image.coordinate = MapStatus.shared.centerCoordinate
                        image.metaData?.latitude = image.coordinate.latitude
                        image.metaData?.longitude = image.coordinate.longitude
                        if let data = image.updateData(data), image.saveImageAndCreatePreview(data: data){
                            AppData.shared.addItem(image)
                            AppData.shared.sortItemsByDate(ascending: ViewFilter.shared.defaultSortAscending)
                            AppData.shared.save()
                            DispatchQueue.main.async {
                                self.completionHandler?()
                            }
                        }
                    }
                    else if image.copyImageAndCreatePreview(from: url, original: img){
                        if image.metaData!.hasGPSData{
                            image.coordinate = CLLocationCoordinate2D(latitude: image.metaData!.latitude!, longitude: image.metaData!.longitude!)
                        }
                        AppData.shared.addItem(image)
                        AppData.shared.sortItemsByDate(ascending: ViewFilter.shared.defaultSortAscending)
                        AppData.shared.save()
                        DispatchQueue.main.async {
                            self.completionHandler?()
                        }
                    }
                }
            }
            
        }
        Self.shared = nil
    }
    
}








/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import AVFoundation
import CoreLocation
import PhotosUI

extension MainViewController {
    
    func openHelp(at button: NSButton) {
        let controller = HelpViewController()
        controller.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    func openViewSettings(at button: NSButton) {
        let controller = ViewSettingsViewController()
        controller.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    func openPreferences(at button: NSButton) {
        let controller = PreferencesViewController()
        controller.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    func addImagesFromFiles(onCompletion: (() -> Void)? = nil) {
        ImagePicker.shared = ImagePicker(controller: self)
        ImagePicker.shared!.addImagesFromFiles(atCenter: false, onCompletion: onCompletion)
    }
    
    func editImage(_ image: ImageItem) {
        let controller = EditImageViewController(item: image)
        if ModalWindow.run(title: "editImage".localize(), viewController: controller, outerWindow: MainWindowController.instance.window!, minSize: CGSize(width: 300, height: 200)) == .OK{
            
        }
    }
    
}







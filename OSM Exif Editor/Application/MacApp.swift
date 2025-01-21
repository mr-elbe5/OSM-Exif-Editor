/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI
import CoreLocation

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        FileManager.initializeDirs()
        TileProvider.shared = ServerTileProvider()
        World.setMaxZoom(18)
        World.scrollWidthFactor = 1
        MapDefaults.startZoom = 8
        Preferences.load()
        NSApp.appearance = NSAppearance(named: .darkAqua)
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        Preferences.shared.save()
        let count = FileManager.default.deleteTemporaryFiles()
        if count > 0{
            debugPrint("\(count) temporary file(s) deleted")
        }
    }
    
}

@main
struct MacApp: App {
    
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        Window("OSM Maps", id: "main") {
            MainView()
                .onGeometryChange(for: CGSize.self) { proxy in
                    proxy.size
                } action: { newSize in
                    MapStatus.shared.bounds = CGRect(origin: .zero, size: newSize)
                    //debugPrint(newSize)
                    MapTiles.shared.updateTiles()
                    MapTiles.shared.update()
                }
        }
    }
}

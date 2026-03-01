/*
 OSM Maps (Mac)
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        BasePaths.initializeDirs()
        World.setMaxZoom(18)
        World.scrollWidthFactor = 1
        MapDefaults.startZoom = 8
        Preferences.load()
        MapStatus.load()
        AppData.loadData()
        MapDefaults.startZoom = 14
        MainWindowController.instance.showWindow(nil)
        print("current UTC offset: \(UTCOffset.current.value)")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        Preferences.shared.save()
        MapStatus.shared.save()
        AppData.shared.save()
        let count = FileManager.default.deleteTemporaryFiles()
        if count > 0{
            Log.debug("\(count) temporary file(s) deleted")
        }
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}


/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import SwiftUI

@Observable class MainStatus: NSObject{
    
    static var shared = MainStatus()
    
    var hideCrossButton: Bool = true
    var hideBottomMenu: Bool = true
    
}

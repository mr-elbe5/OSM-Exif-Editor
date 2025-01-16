/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import SwiftUI
import CoreLocation

struct HideMod: ViewModifier {
    
    var hidden: Bool
    
    init(hidden: Bool) {
        self.hidden = hidden
    }
    
    func body(content: Content) -> some View {
        if hidden {
            content.hidden()
        }
        else {
            content
        }
    }
}

struct MenuIconImageMod: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 18))
            .frame(width: 20, height: 30)
    }
}

struct MapIconImageMod: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 16))
            .foregroundColor(Color.init(red: 0.2, green: 0.2, blue: 0.2))
    }
}

struct OffsetMod: ViewModifier {
    
    var offset: CGPoint
    
    init(offset: CGPoint){
        self.offset = offset
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset.x, y: offset.y)
    }
}

extension View{
    
    func hide(_ hidden: Bool) -> some View {
        modifier(HideMod(hidden: hidden))
    }
    
    func menuIconImage() -> some View {
        modifier(MenuIconImageMod())
    }
    
    func mapIconImage() -> some View {
        modifier(MapIconImageMod())
    }
    
    func offset(_ offset: CGPoint) -> some View {
        modifier(OffsetMod(offset: offset))
    }
    
}


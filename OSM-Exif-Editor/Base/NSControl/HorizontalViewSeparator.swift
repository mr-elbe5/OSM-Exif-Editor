/*
 E5MacOSUI
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

class HorizontalViewSeparator: NSControl{
    
    var trackingArea: NSTrackingArea? = nil
    
    var delegate: ViewSeparatorDelegate? = nil
    
    init(){
        super.init(frame: .zero)
        backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func resetCursorRects(){
        addCursorRect(visibleRect, cursor: NSCursor.resizeUpDown)
    }
    
    override func mouseDragged(with event: NSEvent) {
        if event.type == .leftMouseDragged{
            delegate?.dragged(by: event.deltaY)
        }
    }
    
    func clearTrackingAreas() {
        if let trackingArea = trackingArea { removeTrackingArea(trackingArea) }
        trackingArea = nil
    }
    
    override func updateTrackingAreas() {
        clearTrackingAreas()
        let area = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow], owner: self, userInfo: nil)
        addTrackingArea(area)
        trackingArea = area
    }
    
    override func viewWillMove(toWindow newWindow: NSWindow?) {
        if newWindow == nil { clearTrackingAreas() }
        else { updateTrackingAreas() }
    }
    
    override func mouseEntered(with event: NSEvent) { updateCursor(with: event) }
    override func mouseExited(with event: NSEvent)  { updateCursor(with: event) }
    override func mouseMoved(with event: NSEvent)   { updateCursor(with: event) }
    override func cursorUpdate(with event: NSEvent) {}
    
    func updateCursor(with event: NSEvent) {
        let p = convert(event.locationInWindow, from: nil)
        if bounds.contains(p) {
            NSCursor.resizeUpDown.set()
        } else {
            NSCursor.arrow.set()
        }
    }
    
}

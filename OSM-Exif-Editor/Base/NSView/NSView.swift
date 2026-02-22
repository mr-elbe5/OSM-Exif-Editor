/*
 E5MacOSUI
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */


import AppKit

extension NSView{
    
    var backgroundColor: NSColor? {
        get {
            guard let color = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    @discardableResult
    func setBackground(_ color:NSColor) -> NSView{
        backgroundColor = color
        return self
    }
    
    func setRoundedBorders(){
        if let layer = layer{
            layer.borderWidth = 0.5
            layer.cornerRadius = 5
        }
    }
    
    func unsetRoundedBorders(){
        if let layer = layer{
            layer.borderWidth = 0
            layer.cornerRadius = 0
        }
    }

    func setGrayRoundedBorders(){
        if let layer = layer{
            layer.borderColor = NSColor.lightGray.cgColor
            layer.borderWidth = 0.5
            layer.cornerRadius = 10
        }
    }
    
    func setWhiteRoundedBorders(){
        if let layer = layer{
            layer.borderColor = NSColor.white.cgColor
            layer.borderWidth = 1
            layer.cornerRadius = 5
        }
    }
    
    @discardableResult
    func compressable() -> NSView{
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return self
    }
    
    @objc func setupView(){
    }
    
    func addLabeledView(name: String, view: NSView, upperView: NSView? = nil, insets: OSInsets = .zero) -> NSView{
        let line = NSView()
        let label = NSTextField(labelWithString: name.localize() + ": ")
        label.textColor = .white
        line.addSubviewWithAnchors(label, leading: line.leadingAnchor, insets: .smallInsets)
        line.addSubviewWithAnchors(view, top: line.topAnchor, leading: label.trailingAnchor, trailing: line.trailingAnchor, bottom: line.bottomAnchor, insets: .smallInsets)
        label.centerY(view.centerYAnchor)
        addSubviewBelow(line, upperView: upperView, insets: insets)
        return line
    }
    
    func addHorizontalDivider(upperView: NSView? = nil, color: NSColor = .lightGray, insets: OSInsets = .narrowInsets) -> NSView{
        let divider = NSView()
        divider.backgroundColor = color
        addSubviewBelow(divider, upperView: upperView, insets: insets)
            .height(1)
        return divider
    }

}

class FlippedView: NSView{
    
    override var isFlipped: Bool {
        return true
    }
    
}


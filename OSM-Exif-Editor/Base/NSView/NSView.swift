/*
 E5MacOSUI
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */


import AppKit

public extension NSView {
    
    var highPriority : Float{
        900
    }
    
    var midPriority : Float{
        500
    }
    
    var lowPriority : Float{
        300
    }
    
    static var defaultPriority : Float{
        800
    }
    
    //anchors
    
    func resetConstraints(){
        for constraint in constraints{
            constraint.isActive = false
        }
    }
    
    @discardableResult
    func setAnchors(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, insets: NSEdgeInsets = .zero) -> NSView{
        translatesAutoresizingMaskIntoConstraints = false
        return self.top(top, inset: insets.top)
            .leading(leading, inset: insets.left)
            .trailing(trailing, inset: -insets.right)
            .bottom(bottom, inset: -insets.bottom)
    }

    @discardableResult
    func setAnchors(centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) -> NSView{
        translatesAutoresizingMaskIntoConstraints = false
        return self.centerX(centerX)
            .centerY(centerY)
    }
    
    @discardableResult
    func top(_ top: NSLayoutYAxisAnchor?, inset: CGFloat = 0, priority: Float = defaultPriority) -> NSView{
        if let top = top{
            let constraint = topAnchor.constraint(equalTo: top, constant: inset)
            if priority != NSView.defaultPriority{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func leading(_ leading: NSLayoutXAxisAnchor?, inset: CGFloat = 0, priority: Float = defaultPriority) -> NSView{
        if let leading = leading{
            let constraint = leadingAnchor.constraint(equalTo: leading, constant: inset)
            if priority != NSView.defaultPriority{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func trailing(_ trailing: NSLayoutXAxisAnchor?, inset: CGFloat = 0, priority: Float = defaultPriority) -> NSView{
        if let trailing = trailing{
            let constraint = trailingAnchor.constraint(equalTo: trailing, constant: inset)
            if priority != NSView.defaultPriority{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func bottom(_ bottom: NSLayoutYAxisAnchor?, inset: CGFloat = 0, priority: Float = defaultPriority) -> NSView{
        if let bottom = bottom{
            let constraint = bottomAnchor.constraint(equalTo: bottom, constant: inset)
            if priority != NSView.defaultPriority{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerX(_ centerX: NSLayoutXAxisAnchor?, priority: Float = defaultPriority) -> NSView{
        if let centerX = centerX{
            let constraint = centerXAnchor.constraint(equalTo: centerX)
            if priority != NSView.defaultPriority{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerY(_ centerY: NSLayoutYAxisAnchor?, priority: Float = defaultPriority) -> NSView{
        if let centerY = centerY{
            let constraint = centerYAnchor.constraint(equalTo: centerY)
            if priority != NSView.defaultPriority{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat, inset: CGFloat = 0, priority: Float = defaultPriority) -> NSView{
        let constraint = widthAnchor.constraint(equalToConstant: width)
        if priority != NSView.defaultPriority{
            constraint.priority = NSLayoutConstraint.Priority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func width(_ anchor: NSLayoutDimension, inset: CGFloat = 0, priority: Float = defaultPriority) -> NSView{
        let constraint = widthAnchor.constraint(equalTo: anchor, constant: inset)
        if priority != NSView.defaultPriority{
            constraint.priority = NSLayoutConstraint.Priority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func minWidth(_ anchor: Int, priority: Float = defaultPriority) -> NSView{
        let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(anchor))
        if priority != NSView.defaultPriority{
            constraint.priority = NSLayoutConstraint.Priority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func width(_ anchor: NSLayoutDimension, percentage: CGFloat, inset: CGFloat = 0, priority: Float = defaultPriority) -> NSView{
        let constraint = widthAnchor.constraint(equalTo: anchor, multiplier: percentage, constant: inset)
        if priority != NSView.defaultPriority{
            constraint.priority = NSLayoutConstraint.Priority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat, priority: Float = defaultPriority) -> NSView{
        let constraint = heightAnchor.constraint(equalToConstant: height)
        if priority != NSView.defaultPriority{
            constraint.priority = NSLayoutConstraint.Priority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func minHeight(_ anchor: Int, priority: Float = defaultPriority) -> NSView{
        let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(anchor))
        if priority != NSView.defaultPriority{
            constraint.priority = NSLayoutConstraint.Priority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func height(_ anchor: NSLayoutDimension, inset: CGFloat = 0, priority: Float = defaultPriority) -> NSView{
        let constraint = heightAnchor.constraint(equalTo: anchor, constant: inset)
        if priority != NSView.defaultPriority{
            constraint.priority = NSLayoutConstraint.Priority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func height(_ anchor: NSLayoutDimension, percentage: CGFloat, inset: CGFloat = 0, priority: Float = defaultPriority) -> NSView{
        let constraint = heightAnchor.constraint(equalTo: anchor, multiplier: percentage, constant: inset)
        if priority != NSView.defaultPriority{
            constraint.priority = NSLayoutConstraint.Priority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    func getZeroHeightConstraint() -> NSLayoutConstraint?{
        let constraint = heightAnchor.constraint(equalToConstant: 0.0)
        constraint.priority = NSLayoutConstraint.Priority(950)
        constraint.isActive = false
        return constraint
    }
    
    @discardableResult
    func removeAllConstraints() -> NSView{
        for constraint in self.constraints{
            removeConstraint(constraint)
        }
        return self
    }
    
    // subviews
    
    @discardableResult
    func addSubviewFilling(_ subview: NSView, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: insets)
        return subview
    }
    
    @discardableResult
    func addSubviewFillingSafeArea(_ subview: NSView, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, insets: insets)
        return subview
    }
    
#if os(iOS)
    @discardableResult
    func addSubviewFillingSafeAreaWithKeyboard(_ subview: NSView, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, bottom: keyboardLayoutGuide.topAnchor, insets: insets)
        return subview
    }
#endif
    
    @discardableResult
    func addSubviewWithAnchors(_ subview: NSView, top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: top, leading: leading, trailing: trailing, bottom: bottom, insets: insets)
        return subview
    }
    
    @discardableResult
    func addSubviewCentered(_ subview: NSView, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) -> NSView{
        addSubview(subview)
        subview.setAnchors(centerX: centerX,centerY: centerY)
        return subview
    }
    
    @discardableResult
    func addSubviewBelow(_ subview: NSView, upperView: NSView? = nil, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: upperView?.bottomAnchor ?? topAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: insets)
        return subview
    }
    
    @discardableResult
    func addSubviewCenteredBelow(_ subview: NSView, upperView: NSView? = nil, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: upperView?.bottomAnchor ?? topAnchor, insets: insets)
            .centerX(centerXAnchor)
        return subview
    }
    
    @discardableResult
    func addSubviewToRight(_ subview: NSView, leftView: NSView? = nil, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: topAnchor, leading: leftView?.trailingAnchor ?? leadingAnchor, bottom: bottomAnchor, insets: insets)
        return subview
    }
    
    @discardableResult
    func addSubviewToLeft(_ subview: NSView, rightView: NSView? = nil, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: topAnchor, trailing: rightView?.leadingAnchor ?? trailingAnchor, bottom: bottomAnchor, insets: insets)
        return subview
    }
    
    @discardableResult
    func connectToBottom(of parentView: NSView, inset: Double = NSEdgeInsets.defaultInset) -> NSView{
        self.bottom(parentView.bottomAnchor, inset: -inset)
        return self
    }
    
    @discardableResult
    func connectToRight(of parentView: NSView, inset: Double = NSEdgeInsets.defaultInset) -> NSView{
        trailing(parentView.trailingAnchor, inset: -inset)
        return self
    }
    
    @discardableResult
    func connectToLeft(of parentView: NSView, inset: Double = NSEdgeInsets.defaultInset) -> NSView{
        leading(parentView.leadingAnchor, inset: inset)
        return self
    }
    
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func removeSubview(_ view : NSView) {
        for subview in subviews {
            if subview == view{
                subview.removeFromSuperview()
                break
            }
        }
    }

}

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
    
    func addLabeledView(name: String, view: NSView, upperView: NSView? = nil, insets: NSEdgeInsets = .zero) -> NSView{
        let line = NSView()
        let label = NSTextField(labelWithString: name.localize() + ": ")
        label.textColor = .white
        line.addSubviewWithAnchors(label, leading: line.leadingAnchor, insets: .smallInsets)
        line.addSubviewWithAnchors(view, top: line.topAnchor, leading: label.trailingAnchor, trailing: line.trailingAnchor, bottom: line.bottomAnchor, insets: .smallInsets)
        label.centerY(view.centerYAnchor)
        addSubviewBelow(line, upperView: upperView, insets: insets)
        return line
    }
    
    func addHorizontalDivider(upperView: NSView? = nil, color: NSColor = .lightGray, insets: NSEdgeInsets = .narrowInsets) -> NSView{
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


/*
 E5MacOSUI
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

class VerticalSplitView: NSView{
    
    var topView: NSView
    var separator = HorizontalViewSeparator()
    var bottomView: NSView
    var bottomViewHeightConstraint = NSLayoutConstraint()
    
    var minBottomHeight: CGFloat = 300
    
    var defaultBottomHeight: CGFloat{
        minBottomHeight
    }
    
    var maxBottomHeight: CGFloat{
        bounds.height / 2
    }
    
    init(topView: NSView, bottomView: NSView) {
        self.topView = topView
        self.bottomView = bottomView
        super.init(frame: .zero)
        self.bottomViewHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: minBottomHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        addSubviewBelow(topView, insets: OSInsets(top: 0, left: 2, bottom: 0, right: 0))
        separator.delegate = self
        addSubviewBelow(separator, upperView: topView, insets: .zero)
            .height(6)
        addSubviewBelow(bottomView, upperView: separator, insets: .zero)
            .connectToBottom(of: self)
        bottomViewHeightConstraint.isActive = true
    }
    
    func setBottomHeight(_ height: CGFloat){
        bottomViewHeightConstraint.constant = height
    }
    
    func closeBottomView(){
        setBottomHeight(0)
    }
    
    func openBottomView(){
        setBottomHeight(defaultBottomHeight)
    }
    
    func toggleBottomView(){
        if bottomViewHeightConstraint.constant <= minBottomHeight{
            setBottomHeight(defaultBottomHeight)
        }
        else{
            setBottomHeight(0)
        }
    }
    
}

extension VerticalSplitView: ViewSeparatorDelegate{
    
    func dragged(by dx: CGFloat){
        bottomViewHeightConstraint.constant = min(max(minBottomHeight, bottomViewHeightConstraint.constant - dx), maxBottomHeight)
    }
    
}

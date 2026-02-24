/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit


class HelpViewController: PopoverViewController {
    
    var contentView: HelpView{
        view as! HelpView
    }
    
    override func loadView() {
        view = HelpView(controller: self)
        view.frame = CGRect(origin: .zero, size: CGSize(width: 500, height: 0))
        contentView.setupView(height: MainViewController.shared.view.frame.height/2)
    }
    
}

class HelpView: PopoverView{
    
    func setupView(height: CGFloat) {
        let scrollView = NSScrollView()
        let contentView = NSView()
        scrollView.asVerticalScrollView(contentView: contentView)
        addSubviewFilling(scrollView)
            .height(height)
        var header = NSTextField(labelWithString: "help".localize()).asHeadline()
        contentView.addSubviewBelow(header)
        var text = NSTextField(wrappingLabelWithString: "helpText".localize())
        contentView.addSubviewBelow(text, upperView: header)
            .connectToBottom(of: contentView)
    }
    
}

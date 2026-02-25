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
        var header = NSTextField(labelWithString: "helpApp".localize()).asHeadline()
        contentView.addSubviewBelow(header)
        var text = NSTextField(wrappingLabelWithString: "helpAppText".localize())
        contentView.addSubviewBelow(text, upperView: header)
        header = NSTextField(labelWithString: "helpTrack".localize()).asHeadline()
        contentView.addSubviewBelow(header, upperView: text)
        text = NSTextField(wrappingLabelWithString: "helpTrackText".localize())
        contentView.addSubviewBelow(text, upperView: header)
            .connectToBottom(of: contentView)
    }
    
}

/*
 Image Companion - a photo organizer and map based exif editor
 Copyright (C) 2023 Michael Roennau
*/

import Cocoa
import CoreLocation

class SideTopView: NSView {
    
    enum ViewType: Int {
        case details
        case edit
        case track
    }
    
    var viewSelector: NSSegmentedControl!
    var containerView = NSView()
    var scrollView = NSScrollView()
    var detailView = ImageDetailView()
    var editView = ImageEditView()
    var trackView = TrackEditView()
    var currentType: ViewType = .details
    
    var image: ImageData?{
        ImageEditContext.shared.detailImage
    }
    
    init(){
        super.init(frame: .zero)
        viewSelector = NSSegmentedControl(labels: ["details".localize(),"edit".localize(),"track".localize()], trackingMode: .selectOne, target: self, action: #selector(changeView))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        viewSelector.selectedSegment = ViewType.details.rawValue
        addSubviewBelow(viewSelector, insets: .smallInsets)
        let divider = NSView()
        divider.backgroundColor = .lightGray
        addSubviewBelow(divider, upperView: viewSelector, insets: .zero)
            .height(1)
        detailView.setupView()
        editView.setupView()
        trackView.setupView()
        editView.delegate = self
        scrollView.asVerticalScrollView(contentView: containerView)
        addSubviewBelow(scrollView, upperView: divider, insets: .zero)
            .connectToBottom(of: self)
        setImageView(currentType)
    }
    
    @objc func changeView(){
        if let viewType = ViewType(rawValue: viewSelector.indexOfSelectedItem){
            setImageView(viewType)
        }
    }
    
    func detailImageDidChange(){
        setImageView(.details)
    }
    
    func setImageView(_ type: ViewType){
        currentType = type
        containerView.removeAllSubviews()
        switch(type){
        case .details:
            viewSelector.selectedSegment = 0
            detailView.update()
            containerView.addSubviewFilling(detailView, insets: .zero)
        case .edit:
            viewSelector.selectedSegment = 1
            editView.update()
            containerView.addSubviewFilling(editView, insets: .zero)
        case .track:
            viewSelector.selectedSegment = 2
            trackView.update()
            containerView.addSubviewFilling(trackView, insets: .zero)
        }
    }
    
}

extension SideTopView: ImageEditViewDelegate{
    
    func imageIsModified() {
        MainViewController.shared.updateDetailGridItem()
    }
    
}





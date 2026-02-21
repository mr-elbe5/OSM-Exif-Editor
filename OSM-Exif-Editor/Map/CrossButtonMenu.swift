/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit
import CoreLocation

class CrossButtonMenu: PopoverViewController {
    
    override func loadView() {
        let menuView = CrossButtonMenuView(controller: self)
        menuView.setupView()
        menuView.width(250)
        view = menuView
        menuView.setupView()
    }
    
}

class CrossButtonMenuView: PopoverView{
    
    var nameLabel =  NSTextField(labelWithString: "unknownLocation".localize())
    
    override func setupView(){
        backgroundColor = PopoverViewController.backgroundColor
        let coordinate = MapStatus.shared.centerCoordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        addSubviewCenteredBelow(nameLabel)
        let coordinateLabel = NSTextField(labelWithString: location.coordinate.asString)
        addSubviewCenteredBelow(coordinateLabel, upperView: nameLabel)
        let hint = NSTextField(wrappingLabelWithString: "addAtCenterHint".localize(table: "Hints"))
        hint.font = .systemFont(ofSize: 12)
        addSubviewBelow(hint, upperView: coordinateLabel)
            .connectToBottom(of: self)
        CLPlacemark.getPlacemark(for: location){ placemark in
            if let locationmark = placemark{
                self.nameLabel.stringValue = locationmark.asString
            } else{
                self.nameLabel.stringValue = location.coordinate.asString
            }
        }
    }
    
}

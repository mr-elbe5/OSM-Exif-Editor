/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

class MainMenuView: NSView{
    
    var leftMenu = NSView()
    var rightMenu = NSView()
    
    var openFolderButton: NSButton!
    
    var openViewSettingsButton: NSButton!
    var openPreferencesButton: NSButton!
    var openHelpButton: NSButton!
    
    var insets = OSInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    init(){
        super.init(frame: .zero)
        
        openFolderButton = NSButton(icon: "folder", target: self, action: #selector(openFolder))
        openFolderButton.toolTip = "openFolder".localize()
        
        openViewSettingsButton = NSButton(icon: "calendar", target: self, action: #selector(openViewSettings))
        openViewSettingsButton.toolTip = "viewSettings".localize()
        openPreferencesButton = NSButton(icon: "gearshape", target: self, action: #selector(openPreferences))
        openPreferencesButton.toolTip = "settings".localize()
        openHelpButton = NSButton(icon: "questionmark", target: self, action: #selector(openHelp))
        openHelpButton.toolTip = "help".localize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView(){
        backgroundColor = .black
        
        addSubviewWithAnchors(leftMenu, top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, insets: OSInsets.smallInsets)
        leftMenu.addSubviewToRight(openFolderButton, insets: insets)
            .connectToRight(of: leftMenu, inset: .zero)
        
        addSubviewWithAnchors(rightMenu, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: OSInsets.smallInsets)
        rightMenu.addSubviewToRight(openViewSettingsButton, insets: insets)
        rightMenu.addSubviewToRight(openPreferencesButton, leftView: openViewSettingsButton, insets: insets)
        rightMenu.addSubviewToRight(openHelpButton, leftView: openPreferencesButton, insets: insets)
            .connectToRight(of: rightMenu, inset: .zero)
    }
    
    @objc func openFolder(){
        MainViewController.shared.openFolder()
    }
    
    @objc func openViewSettings(){
        MainViewController.shared.openViewSettings(at: openViewSettingsButton)
    }
    
    @objc func openPreferences(){
        MainViewController.shared.openPreferences(at: openPreferencesButton)
    }
    
    @objc func openHelp(){
        MainViewController.shared.openHelp(at: openHelpButton)
    }
    
}
    

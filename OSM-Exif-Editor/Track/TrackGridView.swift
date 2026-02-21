/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

import UniformTypeIdentifiers

class TrackGridView: GridView{
    
    var trackItems: Array<TrackItem>{
        items as! Array<TrackItem>
    }
    
    var menuView = TrackGridMenuView()
    
    init(){
        super.init(idx: 3)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        items.deselectAll()
    }
    
    override func setupView() {
        super.setupView()
        addSubviewWithAnchors(menuView, top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor)
            .width(40)
        menuView.setupView()
        menuView.delegate = self
        addSubviewWithAnchors(scrollView, top: topAnchor, leading: menuView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        setupCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        items.append(contentsOf: AppData.shared.tracks)
        collectionView.reloadData()
    }
    
    override func updateData(){
        items.removeAll()
        items.append(contentsOf: AppData.shared.tracks)
        collectionView.reloadData()
    }
    
}

extension TrackGridView{
    
    override func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let track = trackItems[indexPath.item]
        if track.selected{
            collectionView.selectionIndexPaths.insert(indexPath)
        }
        let gridItem = TrackGridItem(track: track)
        gridItem.isSelected = track.selected
        gridItem.setHighlightState()
        return gridItem
    }
    
}

extension TrackGridView: TrackGridMenuDelegate{
    
    func importTrack() {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = UTType.types(tag: "gpx", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
        openPanel.directoryURL = FileManager.default.homeDirectoryForCurrentUser
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        if openPanel.runModal() == .OK{
            if let url = openPanel.url{
                if url.startAccessingSecurityScopedResource(){
                    if url.pathExtension == "gpx"{
                        importGPXFile(url: url)
                        DispatchQueue.main.async {
                            MainViewController.shared.itemsChanged()
                            self.updateData()
                        }
                    }
                    url.stopAccessingSecurityScopedResource()
                }
            }
        }
    }
    
    private func importGPXFile(url: URL){
        if let track = Track.loadFromFile(gpxUrl: url){
            if track.name.isEmpty{
                let ext = url.pathExtension
                var name = url.lastPathComponent
                name = String(name[name.startIndex...name.index(name.endIndex, offsetBy: -ext.count)])
                Log.debug(name)
                track.name = name
            }
            track.updateFromTrackpoints()
            let item = TrackItem()
            item.track = track
            item.assertPreview()
            AppData.shared.addItem(item)
            AppData.shared.save()
            DispatchQueue.main.async {
                MainViewController.shared.itemsChanged()
                self.updateData()
            }
        }
    }
    
}






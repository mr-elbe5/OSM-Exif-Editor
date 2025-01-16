/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import SwiftUI

@Observable class MapTileGrid: NSObject{
    
    static var shared = MapTileGrid()
    
    var gridWidth: Int = 1
    var gridHeight: Int = 1
    var tileGrid: [[MapTile]] = []
    
    private var centerTilePoint: IntPoint = IntPoint(x: 0,y: 0)
    
    var centerTileOffset: CGSize = .zero
    
    private var horzExtraTiles: Int = 0
    private var vertExtraTiles: Int = 0
    
    override init(){
        super.init()
        updateTileGrid()
    }
    
    func updateTileGrid(){
        tileGrid.removeAll()
        horzExtraTiles = Int(floor(MapStatus.shared.bounds.width/2 / World.tileExtent)) + 1
        vertExtraTiles = Int(floor(MapStatus.shared.bounds.height/2 / World.tileExtent)) + 1
        gridWidth = Int(2 * horzExtraTiles + 1)
        gridHeight = Int(2 * vertExtraTiles + 1)
        //debugPrint("grid size = \(gridWidth) x \(gridHeight)")
        for _ in 0..<gridHeight {
            var row = [MapTile]()
            for _ in 0..<gridWidth {
                row.append(MapTile())
            }
            tileGrid.append(row)
        }
    }
    
    func update(){
        let coordinate = MapStatus.shared.centerCoordinate
        //debugPrint("updating to coordinate \(coordinate)")
        let scaledWorldCenterPoint = MapStatus.shared.scaledWorldCenterPoint
        centerTilePoint = World.tilePoint(coordinate: coordinate, at: MapStatus.shared.zoom)
        // diff of tile edge to center plus offset to tile center
        centerTileOffset = CGSize(width: (Double(centerTilePoint.x)*World.tileExtent - scaledWorldCenterPoint.x + World.tileExtent/2), height: (Double(centerTilePoint.y)*World.tileExtent - scaledWorldCenterPoint.y + World.tileExtent/2))
        //debugPrint("offset: \(tileOffset)")
        updateGrid()
    }
    
    func updateGrid(){
        for y in 0..<gridHeight {
            for x in 0..<gridWidth {
                let currentTile = tileGrid[y][x]
                let newTilePoint = IntPoint(x: centerTilePoint.x - horzExtraTiles + x, y: centerTilePoint.y - vertExtraTiles + y)
                if currentTile.zoom != MapStatus.shared.zoom || currentTile.x != newTilePoint.x || currentTile.y != newTilePoint.y{
                    //debugPrint("changing tile")
                    let tile = MapTile(zoom: MapStatus.shared.zoom, x: newTilePoint.x, y: newTilePoint.y)
                    TileProvider.shared?.getTileImage(tile: tile){ success in
                        if !success{
                            debugPrint("loading tile failed")
                        }
                    }
                    tileGrid[y][x] = tile
                }
            }
        }
    }
    
}

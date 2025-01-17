/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

@Observable class ApplicationData{
    
    static var storeKey = "applicationdata"
    
    static var shared = ApplicationData()
    
    var imageList : ImageItemList
    
    init(){
        imageList = ImageItemList()
    }
    
    func addImage(_ image: ImageData){
        imageList.append(image)
        //debugPrint("\(imageItems.count) image items")
    }
    
}

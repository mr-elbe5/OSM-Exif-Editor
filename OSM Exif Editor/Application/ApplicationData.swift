/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

enum ListId: Int{
    case left
    case right
}

@Observable class ApplicationData{
    
    static var storeKey = "applicationdata"
    
    static var shared = ApplicationData()
    
    var leftImageList : ImageDataList
    var rightImageList : ImageDataList
    
    init(){
        leftImageList = ImageDataList()
        rightImageList = ImageDataList()
    }
    
    func imageList(_ id: ListId) -> ImageDataList{
        if id == .left{
            return leftImageList
        }
        else {
            return rightImageList
        }
    }
    
    func removeAllImages(of id: ListId)
    {
        if id == .left{
            leftImageList.removeAll()
        }else{
            rightImageList.removeAll()
        }
    }
    
    func addImage(_ image: ImageData, to id: ListId){
        if id == .left{
            leftImageList.append(image)
        }else{
            rightImageList.append(image)
        }
        //debugPrint("\(imageList.count) image items")
    }
    
    func sortByDate(id: ListId){
        if id == .left{
            leftImageList.sort(by: { image1, image2 in
                compareByDate(image1: image1, image2: image2)
            })
        }
        else{
            rightImageList.sort(by: { image1, image2 in
                compareByDate(image1: image1, image2: image2)
            })
        }
    }
                               
    func compareByDate(image1: ImageData, image2: ImageData) -> Bool{
        if let date1 = image1.dateTime{
            if let date2 = image2.dateTime as Date?{
                return date1 < date2
            }
            else{
                return true
            }
        }
        return false
    }
                
    func sortByLatitude(id: ListId){
        if id == .left{
            leftImageList.sort(by: { image1, image2 in
                compareByLatitude(image1: image1, image2: image2)
            })
        }
        else{
            rightImageList.sort(by: { image1, image2 in
                compareByLatitude(image1: image1, image2: image2)
            })
        }
    }
    
    func compareByLatitude(image1: ImageData, image2: ImageData) -> Bool{
        if let coordinate1 = image1.coordinate{
            if let coordinate2 = image2.coordinate{
                return coordinate1.latitude > coordinate2.latitude
            }
            else{
                return true
            }
        }
        return false
    }
    
    func sortByLongitude(id: ListId){
        if id == .left{
            leftImageList.sort(by: { image1, image2 in
                compareByLongitude(image1: image1, image2: image2)
            })
        }
        else{
            rightImageList.sort(by: { image1, image2 in
                compareByLongitude(image1: image1, image2: image2)
            })
        }
    }
    
    func compareByLongitude(image1: ImageData, image2: ImageData) -> Bool{
        if let coordinate1 = image1.coordinate{
            if let coordinate2 = image2.coordinate{
                return coordinate1.longitude < coordinate2.longitude
            }
            else{
                return true
            }
        }
        return false
    }
    
}

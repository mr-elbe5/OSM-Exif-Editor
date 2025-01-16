//
//  ImageTransferData.swift
//  OSM Maps
//
//  Created by Michael Rönnau on 04.01.25.
//

import Foundation
import SwiftUI
import CoreLocation

@Observable class PHImageData: Equatable {
    
    static func == (lhs: PHImageData, rhs: PHImageData) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID = UUID()
    let data: Data
    var orientation: CGImagePropertyOrientation = .up
    var utType: String?
    var fileName = ""
    var size: CGSize = .zero
    var coordinate: CLLocationCoordinate2D?
    var metaData = ImageMetaData()
    
    var creationDate: Date? {
        metaData.dateTime
    }
    
    init(data: Data) {
        self.data = data
    }
    
    var osImage: OSImage? {
        OSImage(data: data)
    }
    
    func evaluateExifData(){
        metaData.readData(data: data)
        if let latitude = metaData.latitude, let longitude = metaData.longitude {
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
}

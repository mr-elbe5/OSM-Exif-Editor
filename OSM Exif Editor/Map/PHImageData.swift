//
//  ImageTransferData.swift
//  OSM Maps
//
//  Created by Michael Rönnau on 04.01.25.
//

import Foundation
import SwiftUI
import CoreLocation

@Observable class PHImageData: ImageData {
    
    let localIdentifier: String
    
    init(localIdentifier: String, data: Data) {
        self.localIdentifier = localIdentifier
        super.init(data: data)
    }
    
}

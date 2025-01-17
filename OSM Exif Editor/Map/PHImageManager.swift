//
//  PHImageManager.swift
//  OSM Maps
//
//  Created by Michael Rönnau on 04.01.25.
//

import Foundation
import Photos

extension PHImageManager {
    
    func requestImage(for asset: PHAsset, options: PHImageRequestOptions?) async throws -> PHImageData? {
        return try await withCheckedThrowingContinuation { continuation in
            requestImageDataAndOrientation(for: asset, options: options){ (data, uti, orientation, info) in
                if let error = info?[PHImageErrorKey] as? Error {
                    debugPrint(error.localizedDescription)
                    continuation.resume(returning: nil)
                    return
                }
                if let data = data {
                    let imageData = PHImageData(localIdentifier: asset.localIdentifier, data: data)
                    imageData.orientation = orientation
                    imageData.utType = uti
                    continuation.resume(returning: imageData)
                }
                else{
                    debugPrint("PHImageManager: got no image data")
                    continuation.resume(returning: nil)
                    return
                }
            }
        }
    }
    
}

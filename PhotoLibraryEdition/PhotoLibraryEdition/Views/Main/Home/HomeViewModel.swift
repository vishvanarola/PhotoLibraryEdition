//
//  HomeViewModel.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import Foundation
import Photos
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var videos: [PHAsset] = []
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined
    
    init() {
        requestPhotoLibraryAccess()
    }
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.authorizationStatus = status
                if status == .authorized || status == .limited {
                    self?.fetchVideos()
                }
            }
        }
    }
    
    private func fetchVideos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        let fetchedVideos = PHAsset.fetchAssets(with: fetchOptions)
        var assets: [PHAsset] = []
        fetchedVideos.enumerateObjects { (asset, _, _) in
            assets.append(asset)
        }
        self.videos = assets
    }
}

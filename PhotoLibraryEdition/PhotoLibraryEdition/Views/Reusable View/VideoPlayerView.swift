//
//  VideoPlayerView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 04/07/25.
//

import SwiftUI
import AVKit
import Photos

struct VideoPlayerView: UIViewControllerRepresentable {
    let asset: PHAsset

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerVC = AVPlayerViewController()
        playerVC.showsPlaybackControls = true
        loadPlayer(from: asset) { player in
            DispatchQueue.main.async {
                playerVC.player = player
                player.play()
            }
        }
        return playerVC
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}

    private func loadPlayer(from asset: PHAsset, completion: @escaping (AVPlayer) -> Void) {
        let options = PHVideoRequestOptions()
        options.version = .original
        options.deliveryMode = .highQualityFormat

        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
            if let urlAsset = avAsset as? AVURLAsset {
                let player = AVPlayer(url: urlAsset.url)
                completion(player)
            }
        }
    }
}

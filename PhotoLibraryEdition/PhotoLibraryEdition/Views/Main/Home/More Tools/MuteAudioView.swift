//
//  MuteAudioView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 20/06/25.
//

import SwiftUI
import PhotosUI
import AVKit
import AVFoundation

struct MuteAudioView: View {
    @State private var isVideoPicked = false
    @State private var showVideoPicker = false
    @State private var pickedVideoURL: URL? = nil
    @State private var player: AVPlayer? = nil
    @State private var isMutedVideoReady = false
    @State private var mutedVideoURL: URL? = nil
    @State private var isShowingMutedVideo = false
    @State private var isPlaying = false
    @State private var showToast = false
    @State private var showNoInternetAlert: Bool = false
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                videoView
                Spacer()
                if isVideoPicked {
                    outputButton
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea()
            
            if showToast {
                VStack {
                    Spacer()
                    Text("Video mute successfully")
                        .font(FontConstants.MontserratFonts.medium(size: 17))
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 50)
                }
            }
        }
        .animation(.easeInOut, value: showToast)
        .sheet(isPresented: $showVideoPicker) {
            VideoPicker { url in
                self.pickedVideoURL = url
                if let url = url {
                    let newPlayer = AVPlayer(url: url)
                    self.player = newPlayer
                    self.isVideoPicked = true
                    self.isShowingMutedVideo = false
                    self.isPlaying = false
                    self.configurePlayer(newPlayer)
                }
            }
        }
        .noInternetAlert(isPresented: $showNoInternetAlert)
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: isVideoPicked ? "ic_share" : "ic_plus",
            headerTitle: "Mute Audio",
            leftButtonAction: {
                AdManager.shared.showInterstitialAd()
                isTabBarHidden = false
                navigationPath.removeLast()
            },
            rightButtonAction: {
                if isVideoPicked, let mutedURL = mutedVideoURL {
                    shareVideo(url: mutedURL)
                } else {
                    showVideoPicker = true
                }
            }
        )
    }
    
    var videoView: some View {
        Group {
            if let player = player {
                ZStack {
                    VideoPlayer(player: player)
                        .cornerRadius(12)
                        .padding(.all, 20)
                        .onAppear {
                            player.pause()
                            isPlaying = false
                            
                            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                                player.seek(to: .zero) { _ in
                                    isPlaying = false
                                }
                            }
                        }
                        .onDisappear {
                            player.pause()
                            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                        }
                    Button {
                        AdManager.shared.showInterstitialAd()
                        if isPlaying {
                            player.pause()
                        } else {
                            player.play()
                        }
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(redThemeColor.opacity(0.5))
                            .shadow(radius: 10)
                    }
                }
            } else {
                Text("Pick a video to mute")
                    .font(FontConstants.MontserratFonts.medium(size: 17))
                    .foregroundStyle(.black)
                    .padding()
            }
        }
    }
    
    var outputButton: some View {
        Button {
            if ReachabilityManager.shared.isNetworkAvailable {
                if PremiumManager.shared.isPremium || !PremiumManager.shared.hasUsed() {
                    AdManager.shared.showInterstitialAd()
                    if let url = pickedVideoURL {
                        muteVideo(originalURL: url)
                    }
                } else {
                    navigationPath.append(HomeDestination.premium)
                }
            } else {
                showNoInternetAlert = true

            }
        } label: {
            Text("Mute Audio")
                .font(FontConstants.MontserratFonts.semiBold(size: 22))
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(redThemeColor)
                .cornerRadius(10)
        }
        .padding(.bottom)
        .padding(.horizontal, 20)
    }
    
    func muteVideo(originalURL: URL) {
        let asset = AVURLAsset(url: originalURL)
        
        let composition = AVMutableComposition()
        
        Task {
            do {
                let duration = try await asset.load(.duration)
                
                let videoTracks = try await asset.loadTracks(withMediaType: .video)
                if let videoTrack = videoTracks.first {
                    let videoCompositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
                    try videoCompositionTrack?.insertTimeRange(
                        CMTimeRange(start: .zero, duration: duration),
                        of: videoTrack,
                        at: .zero
                    )
                } else {
                    return
                }
                
                guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
                    return
                }
                
                let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("mutedVideo.mp4")
                try? FileManager.default.removeItem(at: outputURL)
                
                print("Video duration: \(CMTimeGetSeconds(duration)) seconds")
                exportSession.outputURL = outputURL
                exportSession.outputFileType = .mp4
                exportSession.timeRange = CMTimeRange(start: .zero, duration: duration)
                
                exportSession.exportAsynchronously {
                    DispatchQueue.main.async {
                        switch exportSession.status {
                        case .completed:
                            self.mutedVideoURL = outputURL
                            let newPlayer = AVPlayer(url: outputURL)
                            self.player = newPlayer
                            self.isShowingMutedVideo = true
                            self.isPlaying = false
                            configurePlayer(newPlayer)
                            self.showToast = true
                            PremiumManager.shared.markUsed()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.showToast = false
                            }
                        case .failed, .cancelled:
                            print("Export failed: \(exportSession.error?.localizedDescription ?? "Unknown error")")
                        default:
                            break
                        }
                    }
                }
                
            } catch {
                print("Error loading duration: \(error)")
            }
        }
    }
    
    func shareVideo(url: URL) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        rootVC.present(vc, animated: true)
    }
    
    func configurePlayer(_ player: AVPlayer) {
        player.pause()
        isPlaying = false
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero) { _ in
                isPlaying = false
            }
        }
    }
}

#Preview {
    MuteAudioView(isTabBarHidden: .constant(true), navigationPath: .constant(NavigationPath()))
}

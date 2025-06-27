//
//  VideoConvertorView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 20/06/25.
//

import SwiftUI
import PhotosUI
import AVKit
import AVFoundation

struct VideoConvertorView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isVideoPicked = false
    @State private var showVideoPicker = false
    @State private var pickedVideoURL: URL? = nil
    @State private var player: AVPlayer? = nil
    @State private var convertedVideoURL: URL? = nil
    @State private var isPlaying = false
    @State private var showToast = false
    @Binding var isTabBarHidden: Bool
    
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
                    Text("Video converted successfully")
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
                    self.isPlaying = false
                    self.configurePlayer(newPlayer)
                }
            }
        }
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: isVideoPicked ? "ic_share" : "ic_plus",
            headerTitle: "Video Convertor",
            leftButtonAction: {
                isTabBarHidden = false
                presentationMode.wrappedValue.dismiss()
            },
            rightButtonAction: {
                if isVideoPicked, let convertedURL = convertedVideoURL {
                    shareVideo(url: convertedURL)
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
                    Button(action: {
                        if isPlaying {
                            player.pause()
                        } else {
                            player.play()
                        }
                        isPlaying.toggle()
                    }) {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(redThemeColor.opacity(0.5))
                            .shadow(radius: 10)
                    }
                }
            } else {
                Text("Pick a video to convert into mp3")
                    .font(FontConstants.MontserratFonts.medium(size: 17))
                    .foregroundStyle(.black)
                    .padding()
            }
        }
    }
    
    var outputButton: some View {
        Button {
            if let url = pickedVideoURL {
                convertVideo(originalURL: url)
            }
        } label: {
            Text("Video Convertor")
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
    
    func convertVideo(originalURL: URL) {
        let asset = AVURLAsset(url: originalURL)
        let composition = AVMutableComposition()
        
        Task {
            do {
                let duration = try await asset.load(.duration)
                
                let audioTracks = try await asset.loadTracks(withMediaType: .audio)
                guard let audioTrack = audioTracks.first else {
                    print("No audio track found")
                    return
                }
                
                let compositionAudioTrack = composition.addMutableTrack(
                    withMediaType: .audio,
                    preferredTrackID: kCMPersistentTrackID_Invalid
                )
                
                try compositionAudioTrack?.insertTimeRange(
                    CMTimeRange(start: .zero, duration: duration),
                    of: audioTrack,
                    at: .zero
                )
                
                let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("convertedAudio.m4a")
                try? FileManager.default.removeItem(at: outputURL)
                
                guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else {
                    print("Failed to create export session")
                    return
                }
                
                exportSession.outputURL = outputURL
                exportSession.outputFileType = .m4a
                
                exportSession.exportAsynchronously {
                    DispatchQueue.main.async {
                        switch exportSession.status {
                        case .completed:
                            self.convertedVideoURL = outputURL
                            let newPlayer = AVPlayer(url: outputURL)
                            self.player = newPlayer
                            self.isPlaying = false
                            configurePlayer(newPlayer)
                            self.showToast = true
                            PremiumManager.shared.markUsed(feature: PremiumFeature.videoConverter)
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
                print("Error during audio conversion: \(error.localizedDescription)")
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

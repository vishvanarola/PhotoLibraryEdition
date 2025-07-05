//
//  HomeView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI
import Photos

enum HomeDestination: Hashable {
    case muteAudio
    case textEmoji
    case textRepeater
    case textStyleDesign
    case videoConvertor
    case settings
    case premium
}

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    let tools: [(name: String, destination: HomeDestination)] = [
        ("Text\nRepeater", .textRepeater),
        ("Text\nto Emoji", .textEmoji),
        ("Text\nStyle Design", .textStyleDesign),
        ("Mute\nAudio", .muteAudio),
        ("Video\nConvertor", .videoConvertor)
    ]
    @State private var navigationPath = NavigationPath()
    @Binding var isTabBarHidden: Bool
    @Binding var isHiddenBanner: Bool
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                headerView
                videoListView
                moreToolsView
            }
            .ignoresSafeArea()
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case .muteAudio:
                    MuteAudioView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .textEmoji:
                    TextEmojiView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .textRepeater:
                    TextRepeaterView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .textStyleDesign:
                    TextStyleDesignView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .videoConvertor:
                    VideoConvertorView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .settings:
                    SettingsView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .premium:
                    PremiumView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath, isHiddenBanner: $isHiddenBanner)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var headerView: some View {
        ZStack {
            GradientView()
            VStack {
                Spacer()
                HStack {
                    Button {
                        AdManager.shared.showInterstitialAd()
                        isTabBarHidden = true
                        navigationPath.append(HomeDestination.settings)
                    } label: {
                        Image("ic_setting")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Text(appName)
                        .font(FontConstants.SyneFonts.semiBold(size: 23))
                        .foregroundStyle(Color.white)
                    Spacer()
                    if !PremiumManager.shared.isPremium {
                        Button {
                            isHideTabBackPremium = false
                            isTabBarHidden = true
                            navigationPath.append(HomeDestination.premium)
                        } label: {
                            Image("ic_pro")
                                .foregroundColor(.white)
                        }
                    } else {
                        Spacer()
                        Spacer()
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.15)
    }
    
    var videoListView: some View {
        Group {
            switch viewModel.authorizationStatus {
            case .authorized, .limited:
                if viewModel.videos.isEmpty {
                    VStack {
                        Spacer()
                        Text("No videos found in your library.")
                            .font(FontConstants.MontserratFonts.regular(size: 15))
                            .foregroundColor(.primary)
                            .padding()
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.videos, id: \.self) { asset in
                                VideoThumbnailView(asset: asset)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 5)
                    }
                }
            case .denied, .restricted:
                VStack {
                    Spacer()
                    Text("Photo library access denied. Please enable it in Settings.")
                        .font(FontConstants.MontserratFonts.regular(size: 15))
                        .foregroundColor(.red)
                        .padding()
                    Spacer()
                }
            case .notDetermined:
                VStack {
                    Spacer()
                    Text("Requesting access...")
                        .font(FontConstants.MontserratFonts.regular(size: 15))
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                }
            @unknown default:
                VStack {
                    Spacer()
                    Text("Unknown authorization status.")
                        .font(FontConstants.MontserratFonts.regular(size: 15))
                        .foregroundColor(.primary)
                        .padding()
                    Spacer()
                }
            }
        }
    }
    
    var moreToolsView: some View {
        VStack(alignment: .leading) {
            Text("More Tools")
                .font(FontConstants.MontserratFonts.semiBold(size: 20))
                .foregroundStyle(Color.primary)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    Spacer(minLength: 16)
                    ForEach(tools, id: \.destination) { tool in
                        moreToolsButton(toolName: tool.name, destination: tool.destination)
                    }
                    Spacer(minLength: 16)
                }
                .padding(.vertical, 5)
            }
        }
    }
    
    func moreToolsButton(toolName: String, destination: HomeDestination) -> some View {
        HStack {
            Button {
                isTabBarHidden = true
                AdManager.shared.showInterstitialAd()
                navigationPath.append(destination)
            } label: {
                Text(toolName)
                    .font(FontConstants.MontserratFonts.medium(size: 15))
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.leading)
            }
            Image("ic_tools")
        }
        .padding(.top, 5)
        .padding(.bottom)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    colors: [pinkThemeColor.opacity(0.3), .white],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [redThemeColor, pinkThemeColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.3
                )
        )
    }
}

struct VideoThumbnailView: View {
    let asset: PHAsset
    @State private var thumbnail: UIImage? = nil
    @State private var videoName: String = ""
    @State private var videoSize: String = ""
    @State private var isPresentingPlayer = false
    
    var body: some View {
        Group {
            if let thumbnail = thumbnail {
                HStack(spacing: 14) {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(videoName.isEmpty ? "Video Name" : videoName)
                            .font(FontConstants.MontserratFonts.semiBold(size: 15))
                            .lineLimit(2)
                            .foregroundStyle(Color.primary)
                        Text(videoSize.isEmpty ? "--" : videoSize)
                            .font(FontConstants.MontserratFonts.medium(size: 14))
                            .foregroundStyle(textGrayColor)
                            .lineLimit(1)
                    }
                    Spacer()
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 0)
                .onTapGesture {
                    isPresentingPlayer = true
                }
                .sheet(isPresented: $isPresentingPlayer) {
                    VideoPlayerView(asset: asset)
                }
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    ProgressView()
                }
            }
        }
        .onAppear {
            loadThumbnail()
            loadVideoInfo()
        }
    }
    
    private func loadThumbnail() {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.resizeMode = .exact
        let targetSize = CGSize(width: 400, height: 400)
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            if let image = image {
                self.thumbnail = image
            }
        }
    }
    
    private func loadVideoInfo() {
        let resources = PHAssetResource.assetResources(for: asset)
        if let resource = resources.first {
            self.videoName = resource.originalFilename
            if let fileSize = resource.value(forKey: "fileSize") as? Int {
                self.videoSize = formatBytes(fileSize)
            }
        }
    }
    
    private func formatBytes(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}

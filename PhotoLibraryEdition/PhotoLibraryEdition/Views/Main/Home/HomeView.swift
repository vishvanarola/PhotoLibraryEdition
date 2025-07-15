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
    @State private var navigationPath = NavigationPath()
    @State private var showNoInternetAlert: Bool = false
    @State private var enterTextInput: String = "https://example.com/"
    @State private var isFindTapped: Bool = false
    @State private var showToast = false
    @State private var toastText: String = "Copied"
    @State private var isUserAtTop: Bool = true
    @State private var randomVideos = [RandomVideoItem]()
    @Binding var isTabBarHidden: Bool
    @Binding var isHiddenBanner: Bool
    @Namespace private var topID
    let tools: [(name: String, destination: HomeDestination)] = [
        ("Text\nRepeater", .textRepeater),
        ("Text\nto Emoji", .textEmoji),
        ("Text\nStyle Design", .textStyleDesign),
        ("Mute\nAudio", .muteAudio),
        ("Video\nConvertor", .videoConvertor)
    ]
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                VStack {
                    headerView
                    textFieldFindView
                    if !randomVideos.isEmpty {
                        videoListView
                        Spacer()
                    } else {
                        Spacer()
                        noDataView
                        Spacer()
                    }
                    moreToolsView
                }
                if showToast {
                    VStack {
                        Spacer()
                        Text(toastText)
                            .font(FontConstants.MontserratFonts.medium(size: 17))
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 20)
                    }
                }
            }
            .onAppear {
                randomVideos = randomVideosGlob
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
        .noInternetAlert(isPresented: $showNoInternetAlert)
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
                            if ReachabilityManager.shared.isNetworkAvailable {
                                isHideTabBackPremium = false
                                isTabBarHidden = true
                                navigationPath.append(HomeDestination.premium)
                            } else {
                                showNoInternetAlert = true
                            }
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
    
    var textFieldFindView: some View {
        VStack(spacing: 18) {
            ZStack(alignment: .topTrailing) {
                textFieldView
                if !PremiumManager.shared.isPremium {
                    Image("ic_text_pro")
                        .padding(.top, 10)
                        .padding(.trailing, 120)
                }
            }
            findButtonView
        }
    }
    
    var textFieldView: some View {
        HStack(spacing: 20) {
            TextField("", text: $enterTextInput, prompt: Text("Enter or Paste URL")
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundColor(.gray)
            )
            .font(FontConstants.MontserratFonts.semiBold(size: 18))
            .keyboardType(.URL)
            .padding(13)
            .background(.white)
            .cornerRadius(30)
            .shadow(radius: 3)
            Button {
                if !enterTextInput.isEmpty {
                    toastText = "Copied"
                    UIPasteboard.general.string = enterTextInput
                    showToasts()
                }
            } label: {
                Image("ic_circle_copy")
            }
        }
        .frame(height: 50)
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    var findButtonView: some View {
        Button {
            if self.isValidURLRegex(enterTextInput) {
                if PremiumManager.shared.isPremium {
                    if let random = videosArray.randomElement() {
                        isFindTapped = true
                        let newItem = RandomVideoItem(data: random)
                        randomVideosGlob.insert(newItem, at: 0)
                        randomVideos.insert(newItem, at: 0)
                        if randomVideos.count > 50 {
                            randomVideos.removeLast()
                        }
                    }
                } else {
                    isHideTabBackPremium = false
                    isTabBarHidden = true
                    navigationPath.append(HomeDestination.premium)
                }
            } else {
                toastText = "Plase enter a valid URL"
                showToasts()
            }
            
        } label: {
            Text("Find")
                .font(FontConstants.MontserratFonts.semiBold(size: 22))
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(
                            colors: [redThemeColor, pinkThemeColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
                .cornerRadius(30)
        }
        .padding(.horizontal, 20)
    }
    
    var videoListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    Color.clear
                        .frame(height: 1)
                        .background(
                            GeometryReader { geo -> Color in
                                DispatchQueue.main.async {
                                    isUserAtTop = geo.frame(in: .named("scroll")).minY >= -10
                                }
                                return Color.clear
                            }
                        )
                        .id("top")
                    
                    ForEach(randomVideos) { item in
                        VideoThumbnailView(videoData: item.data)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
                .padding(.bottom, 5)
            }
            .coordinateSpace(name: "scroll")
            .onChange(of: randomVideos) { _, _ in
                if !isUserAtTop {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo("top", anchor: .top)
                        }
                    }
                }
            }
        }
    }
    
    var noDataView: some View {
        Image("ic_novideo")
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
    
    func showToasts() {
        withAnimation {
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showToast = false
            }
        }
    }
    
    func isValidURLRegex(_ urlString: String) -> Bool {
        let pattern = #"^(http|https)://([\w-]+(\.[\w-]+)+)([/#?]?.*)$"#
        return urlString.range(of: pattern, options: .regularExpression) != nil
    }
}

struct VideoThumbnailView: View {
    @State var videoData: VideosArrayData?
    @State private var isPresentingPlayer = false
    @State private var showNoInternetAlert: Bool = false
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(.black.opacity(0.1))
                AsyncImage(url: URL(string: videoData?.videoThumb ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 60, height: 60)
                .cornerRadius(10)
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(videoData?.title ?? "Video Name")
                    .font(FontConstants.MontserratFonts.semiBold(size: 15))
                    .lineLimit(2)
                    .foregroundStyle(Color.primary)
                Text(videoData?.size ?? "--")
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
            if ReachabilityManager.shared.isNetworkAvailable {
                isPresentingPlayer = true
            } else {
                showNoInternetAlert = true
            }
        }
        .sheet(isPresented: $isPresentingPlayer) {
            if let urlString = videoData?.videoUrl, let url = URL(string: urlString) {
                VideoPlayerView(videoURL: url)
            } else {
                Text("Invalid video URL")
            }
        }
        .noInternetAlert(isPresented: $showNoInternetAlert)
    }
}

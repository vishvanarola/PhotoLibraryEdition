//
//  HomeView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI
import Photos

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            headerView
            videoListView
            Spacer()
        }
        .ignoresSafeArea()
    }
    
    var headerView: some View {
        ZStack {
            GradientView()
            VStack {
                Spacer()
                HStack {
                    Button {
                        
                    } label: {
                        Image("ic_setting")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Spacer()
                    Text(appName)
                        .font(FontConstants.Fonts.montserrat_Bold(size: 25))
                        .foregroundStyle(Color.white)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image("ic_pro")
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            }
        }
        .frame(height: UIScreen.main.bounds.height*0.15)
    }
    
    var videoListView: some View {
        Group {
            switch viewModel.authorizationStatus {
            case .authorized, .limited:
                if viewModel.videos.isEmpty {
                    Text("No videos found in your library.")
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.videos, id: \.self) { asset in
                                VideoThumbnailView(asset: asset)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }
            case .denied, .restricted:
                Text("Photo library access denied. Please enable it in Settings.")
                    .foregroundColor(.red)
                    .padding()
            case .notDetermined:
                ProgressView("Requesting access...")
                    .padding()
            @unknown default:
                Text("Unknown authorization status.")
                    .padding()
            }
        }
    }
}

struct VideoThumbnailView: View {
    let asset: PHAsset
    @State private var thumbnail: UIImage? = nil
    
    var body: some View {
        Group {
            if let thumbnail = thumbnail {
                HStack {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Video Name")
                            .font(FontConstants.Fonts.montserrat_SemiBold(size: 17))
                            .foregroundStyle(Color.primary)
                        Text("20.09 KB")
                            .font(FontConstants.Fonts.montserrat_Regular(size: 15))
                            .foregroundStyle(Color.primary)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    ProgressView()
                }
            }
        }
        .onAppear {
            loadThumbnail()
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
}

#Preview {
    HomeView()
}

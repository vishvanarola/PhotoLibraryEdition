//
//  HidePhotoView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 29/06/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct HidePhotoView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var hidePhotos: [HidePhotoModel]
    @State private var showPhotoPicker = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImageData: Data?
    @State private var isShowingPhotoPreview = false
    @State private var showNoInternetAlert: Bool = false
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        Group {
            if isShowingPhotoPreview {
                fullPhotoView()
            } else {
                VStack {
                    headerView
                    collagePhohotView
                }
            }
        }
        .ignoresSafeArea()
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedItems,
            maxSelectionCount: 10,
            matching: .images
        )
        .onChange(of: selectedItems) { oldValue, newValue in
            Task {
                await handleImageSelection()
            }
        }
        .noInternetAlert(isPresented: $showNoInternetAlert)
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: "ic_plus",
            headerTitle: "Hide Photos",
            leftButtonAction: {
                AdManager.shared.showInterstitialAd()
                isTabBarHidden = false
                navigationPath.removeLast()
            },
            rightButtonAction: {
                if ReachabilityManager.shared.isNetworkAvailable {
                    if PremiumManager.shared.isPremium || !PremiumManager.shared.hasUsed() {
                        showPhotoPicker = true
                    } else {
                        navigationPath.append(LockRoute.premium)
                    }
                } else {
                    showNoInternetAlert = true
                }
            }
        )
    }
    
    var collagePhohotView: some View {
        Group {
            if hidePhotos.isEmpty {
                Spacer()
                Text("No photos added yet")
                    .font(FontConstants.MontserratFonts.medium(size: 17))
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(hidePhotos, id: \.id) { photo in
                            if let uiImage = UIImage(data: photo.data) {
                                Button {
                                    AdManager.shared.showInterstitialAd()
                                    selectedImageData = photo.data
                                    withAnimation {
                                        isShowingPhotoPreview = true
                                    }
                                } label: {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    func fullPhotoView() -> some View {
        Group {
            ZStack(alignment: .topTrailing) {
                Color.black.ignoresSafeArea()
                if let data = selectedImageData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                }
                
                Button {
                    AdManager.shared.showInterstitialAd()
                    withAnimation {
                        isShowingPhotoPreview = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                }
                .frame(width: 30, height: 30)
                .padding()
                .foregroundColor(.white)
                .padding(.top, 20)
            }
        }
    }
    
    func handleImageSelection() async {
        for item in selectedItems {
            if let data = try? await item.loadTransferable(type: Data.self) {
                let newPhoto = HidePhotoModel(data: data)
                modelContext.insert(newPhoto)
            }
        }
        
        do {
            PremiumManager.shared.markUsed()
            try modelContext.save()
        } catch {
            print("⚠️ Error saving images: \(error)")
        }
        
        selectedItems = []
    }
}

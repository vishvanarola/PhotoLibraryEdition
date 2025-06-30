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
    @State private var showPhotoPicker = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @Query private var hidePhotos: [HidePhotoModel]
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            headerView
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
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
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
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: "ic_plus",
            headerTitle: "Hide Photos",
            leftButtonAction: {
                isTabBarHidden = false
                navigationPath.removeLast()
            },
            rightButtonAction: {
                showPhotoPicker = true
            }
        )
    }
    
    func handleImageSelection() async {
        for item in selectedItems {
            if let data = try? await item.loadTransferable(type: Data.self) {
                let newPhoto = HidePhotoModel(data: data)
                modelContext.insert(newPhoto)
            }
        }
        
        do {
            PremiumManager.shared.markUsed(feature: PremiumFeature.addPhotosInHide)
            try modelContext.save()
        } catch {
            print("⚠️ Error saving images: \(error)")
        }
        
        selectedItems = []
    }
}

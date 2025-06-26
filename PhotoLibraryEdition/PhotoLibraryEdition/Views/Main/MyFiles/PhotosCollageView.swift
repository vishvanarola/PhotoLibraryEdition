//
//  PhotosCollageView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 25/06/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct PhotosCollageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Bindable var collage: Collage
    @State private var showPhotoPicker = false
    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack {
            headerView
            if collage.images.isEmpty {
                Spacer()
                Text("No photos added yet")
                    .font(FontConstants.MontserratFonts.medium(size: 17))
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(collage.images, id: \.id) { collageImage in
                            if let uiImage = UIImage(data: collageImage.data) {
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
        .navigationBarBackButtonHidden(true)
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
            headerTitle: collage.name,
            leftButtonAction: {
                presentationMode.wrappedValue.dismiss()
            },
            rightButtonAction: {
                showPhotoPicker = true
            }
        )
    }
    
    func handleImageSelection() async {
        for item in selectedItems {
            if let data = try? await item.loadTransferable(type: Data.self) {
                let image = CollageImage(data: data)
                image.collage = collage
                collage.images.append(image)
            }
        }
        do {
            try modelContext.save()
        } catch {
            print("⚠️ Error saving images: \(error)")
        }
    }
}

#Preview {
    PhotosCollageView(collage: .init(name: "Demo"))
}

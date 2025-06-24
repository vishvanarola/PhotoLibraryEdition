//
//  MyFilesView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI
import SwiftData

struct MyFilesView: View {
    @State private var showCreateCollage = false
    @State private var collageToEdit: Collage? = nil
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Collage.createdAt, order: .reverse) private var collages: [Collage]

    var body: some View {
        ZStack {
            VStack {
                headerView
                listView
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)

            if showCreateCollage {
                CreateCollageView(isPresented: $showCreateCollage, collageToEdit: collageToEdit)
            }
        }
    }

    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: "ic_plus",
            headerTitle: "My Files",
            leftButtonAction: {
                dismiss()
            },
            rightButtonAction: {
                withAnimation {
                    showCreateCollage = true
                    collageToEdit = nil
                }
            }
        )
    }

    var listView: some View {
        Group {
            if collages.isEmpty {
                VStack {
                    Spacer()
                    Text("No Collages Found")
                        .font(FontConstants.MontserratFonts.medium(size: 18))
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                List {
                    ForEach(collages) { collage in
                        HStack {
                            Image("ic_folder")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(.leading)
                            Text(collage.name)
                                .font(FontConstants.MontserratFonts.medium(size: 18))
                                .foregroundStyle(Color.black)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(textGrayColor.opacity(0.10))
                        .cornerRadius(15)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .padding(.bottom, 10)
                        .padding(.horizontal, 20)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                deleteCollage(collage)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                collageToEdit = collage
                                showCreateCollage = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }

    var emptyStateView: some View {
        VStack {
            Spacer()
            Text("No Collages Found")
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundColor(.gray)
            Spacer()
        }
    }

    private func deleteCollage(_ collage: Collage) {
        modelContext.delete(collage)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete collage: \(error)")
        }
    }
}

#Preview {
    MyFilesView()
}

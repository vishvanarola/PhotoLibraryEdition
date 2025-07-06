//
//  MyFilesView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI
import SwiftData

enum MyFilesRoute: Hashable {
    case photosCollage(Collage)
    case premium
}

struct MyFilesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Collage.createdAt, order: .reverse) private var collages: [Collage]
    @State private var showCreateCollage = false
    @State private var collageToEdit: Collage? = nil
    @State private var navigationPath = NavigationPath()
    @State private var showNoInternetAlert: Bool = false
    @Binding var selectedTab: CustomTab
    @Binding var isTabBarHidden: Bool
    @Binding var isHiddenBanner: Bool
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                VStack {
                    headerView
                    listView
                }
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                
                if showCreateCollage {
                    CreateCollageView(isPresented: $showCreateCollage, collageToEdit: collageToEdit, isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                }
            }
            .navigationDestination(for: MyFilesRoute.self) { route in
                switch route {
                case .photosCollage(let collage):
                    PhotosCollageView(collage: collage, isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                case .premium:
                    PremiumView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath, isHiddenBanner: $isHiddenBanner)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .noInternetAlert(isPresented: $showNoInternetAlert)
        }
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: "ic_plus",
            headerTitle: "My Files",
            leftButtonAction: {
                AdManager.shared.showInterstitialAd()
                withAnimation {
                    selectedTab = .home
                }
            },
            rightButtonAction: {
                if ReachabilityManager.shared.isNetworkAvailable {
                    AdManager.shared.showInterstitialAd()
                    withAnimation {
                        showCreateCollage = true
                        collageToEdit = nil
                    }
                } else {
                    showNoInternetAlert = true
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
                                if ReachabilityManager.shared.isNetworkAvailable {
                                    AdManager.shared.showInterstitialAd()
                                    deleteCollage(collage)
                                } else {
                                    showNoInternetAlert = true
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                if ReachabilityManager.shared.isNetworkAvailable {
                                    AdManager.shared.showInterstitialAd()
                                    collageToEdit = collage
                                    showCreateCollage = true
                                } else {
                                    showNoInternetAlert = true
                                }
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                        .onTapGesture {
                            if ReachabilityManager.shared.isNetworkAvailable {
                                AdManager.shared.showInterstitialAd()
                                isTabBarHidden = true
                                navigationPath.append(MyFilesRoute.photosCollage(collage))
                            } else {
                                showNoInternetAlert = true
                            }
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

//
//  TabBarView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI

enum CustomTab {
    case home, myFiles, lock
}

struct TabBarView: View {
    @State private var selectedTab: CustomTab = .home
    @State private var isTabBarHidden: Bool = false
    @State private var isHiddenBanner: Bool = false
    @ObservedObject var adManager = AdManager.shared
    
    var body: some View {
        VStack {
            Group {
                switch selectedTab {
                case .home:
                    HomeView(isTabBarHidden: $isTabBarHidden, isHiddenBanner: $isHiddenBanner)
                case .myFiles:
                    MyFilesView(selectedTab: $selectedTab, isTabBarHidden: $isTabBarHidden, isHiddenBanner: $isHiddenBanner)
                case .lock:
                    LockScreenView(selectedTab: $selectedTab, isTabBarHidden: $isTabBarHidden, isHiddenBanner: $isHiddenBanner)
                }
            }
            .background(Color(.white).ignoresSafeArea())
            VStack(spacing: 0) {
                if !isTabBarHidden {
                    HStack {
                        tabBarItem(tab: .home, icon: "ic_home", label: "Home")
                        Spacer()
                        tabBarItem(tab: .myFiles, icon: "ic_myfiles", label: "My Files")
                        Spacer()
                        tabBarItem(tab: .lock, icon: "ic_lock", label: "Lock")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .background(
                        Color.white
                            .cornerRadius(30, corners: [.topLeft, .topRight])
                            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
                    )
                }
                if !isHiddenBanner && !PremiumManager.shared.isPremium && adManager.isBannerAdLoaded {
                    BannerAdView()
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func tabBarItem(tab: CustomTab, icon: String, label: String) -> some View {
        let isSelected = selectedTab == tab
        VStack(spacing: 5) {
            Image(icon)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(isSelected ? Color.red : Color(.systemGray3))
            Text(label)
                .font(FontConstants.MontserratFonts.medium(size: 16))
                .foregroundColor(isSelected ? redThemeColor : textGrayColor)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                selectedTab = tab
            }
        }
    }
}

#Preview {
    TabBarView()
}

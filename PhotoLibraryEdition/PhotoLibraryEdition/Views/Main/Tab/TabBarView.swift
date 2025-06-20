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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .myFiles:
                    MyFilesView()
                case .lock:
                    LockScreenView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.white).ignoresSafeArea())
            
            // Custom Tab Bar
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
            selectedTab = tab
        }
    }
}

#Preview {
    TabBarView()
}

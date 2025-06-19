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
            .background(Color(.systemGray6).ignoresSafeArea())
            
            // Custom Tab Bar
            HStack {
                tabBarItem(tab: .home, icon: "ic_home", label: "Home")
                Spacer()
                tabBarItem(tab: .myFiles, icon: "ic_myfiles", label: "My Files")
                Spacer()
                tabBarItem(tab: .lock, icon: "ic_lock", label: "Lock")
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                Color.white
                    .cornerRadius(35, corners: [.topLeft, .topRight])
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
            )
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func tabBarItem(tab: CustomTab, icon: String, label: String) -> some View {
        let isSelected = selectedTab == tab
        VStack(spacing: 5) {
            Image(icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? Color.red : Color(.systemGray3))
            Text(label)
                .font(isSelected ? FontConstants.Fonts.montserrat_SemiBold(size: 16) : FontConstants.Fonts.montserrat_Medium(size: 16))
                .foregroundColor(isSelected ? Color.red : Color(.systemGray3))
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


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

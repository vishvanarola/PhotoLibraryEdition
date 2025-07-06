//
//  SettingsView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 26/06/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    @State private var isShowingShareSheet = false
    @State private var showNoInternetAlert: Bool = false
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                headerView
                if !PremiumManager.shared.isPremium {
                    premiumView
                }
                ScrollView {
                    moreOptionsView
                }
                .padding(.horizontal, 20)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $isShowingShareSheet) {
            if let appUrl = appLink {
                ActivityView(activityItems: [appUrl])
            }
        }
        .noInternetAlert(isPresented: $showNoInternetAlert)
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: nil,
            headerTitle: "Settings",
            leftButtonAction: {
                AdManager.shared.showInterstitialAd()
                isHideTabBackPremium = true
                isTabBarHidden = false
                navigationPath.removeLast()
            },
            rightButtonAction: nil
        )
    }
    
    var premiumView: some View {
        Button {
            if ReachabilityManager.shared.isNetworkAvailable {
                AdManager.shared.showInterstitialAd()
                isHideTabBackPremium = true
                navigationPath.append(HomeDestination.premium)
            } else {
                showNoInternetAlert = true
            }
        } label: {
            ZStack {
                HStack(spacing: 0) {
                    Image("ic_crown")
                    VStack(alignment: .leading, spacing: 9) {
                        Text("Get Premium")
                            .font(FontConstants.SyneFonts.medium(size: 22))
                            .foregroundStyle(Color.black)
                        Text("Get full access to all our features")
                            .font(FontConstants.SyneFonts.regular(size: 18))
                            .foregroundStyle(Color.black.opacity(0.7))
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 20)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            pinkGradientColor.opacity(0.5),
                            Color(red: 1.0, green: 109/255, blue: 137/255).opacity(0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(30)
                .clipped()
            }
            .padding(.horizontal, 20)
        }
    }
    
    var moreOptionsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("More Options")
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundStyle(Color.black)
            VStack(spacing: 20) {
                options(image: "ic_star", text: "Rate Us") {
                    if let url = appRateLink {
                        openUrls(url)
                    }
                }
                options(image: "ic_secure", text: "Privacy & Policy") {
                    if let url = privacyPolicy {
                        openUrls(url)
                    }
                }
                options(image: "ic_terms", text: "Terms & Condition") {
                    if let url = termsCondition {
                        openUrls(url)
                    }
                }
            }
            .padding(.vertical, 25)
            .background(textGrayColor.opacity(0.10))
            .cornerRadius(20)
            VStack(spacing: 18) {
                options(image: "ic_share_app", text: "Share App") {
                    isShowingShareSheet = true
                }
            }
            .padding(.vertical, 20)
            .background(textGrayColor.opacity(0.10))
            .cornerRadius(20)
        }
    }
    
    func options(image: String, text: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 26) {
                Image(image)
                    .resizable()
                    .frame(width: 45, height: 45)
                Text(text)
                    .font(FontConstants.MontserratFonts.medium(size: 18))
                    .foregroundStyle(Color.black)
                Spacer()
            }
            .padding(.leading, 28)
        }
    }
    
    func openUrls(_ url: URL) {
        if ReachabilityManager.shared.isNetworkAvailable {
            openURL(url)
        } else {
            showNoInternetAlert = true
        }
    }
}

//
//  PremiumView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 26/06/25.
//

import SwiftUI
import RevenueCat

struct PremiumView: View {
    @ObservedObject private var premiumManager = PremiumManager.shared
    @Environment(\.openURL) var openURL
    @State private var selectedPlanIndex = 0
    @State private var showPurchaseError = false
    @State private var purchaseErrorMessage = ""
    @State private var isPurchasing = false
    @State private var showPurchaseSuccess = false
    @State private var showRestoreSuccess = false
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    @Binding var isHiddenBanner: Bool
    
    var body: some View {
        ZStack {
            backgroundView.ignoresSafeArea()
            
            VStack(spacing: 0) {
                restoreView
                
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 30) {
                            headerView
                            featuresView
                            subscriptionPlansView
                            Color.clear
                                .frame(height: 1)
                                .id("BOTTOM")
                        }
                        .padding(.top, 10)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                            withAnimation(.easeOut(duration: 2)) {
                                proxy.scrollTo("BOTTOM", anchor: .bottom)
                            }
                        }
                    }
                }
                
                VStack(spacing: 16) {
                    getFullAccessButton
                    footerView
                }
                .padding(.bottom)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            isHiddenBanner = true
            premiumManager.configureRevenueCat()
        }
        .onDisappear {
            isHiddenBanner = false
        }
        .alert(isPresented: $showPurchaseError) {
            Alert(
                title: Text("Error"),
                message: Text(purchaseErrorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showPurchaseSuccess) {
            Alert(
                title: Text("Purchase Successfully"),
                message: Text("Enjoy app without ads!"),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showRestoreSuccess) {
            Alert(
                title: Text("Restore Successfully"),
                message: Text("Enjoy app without ads!"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    var backgroundView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [redThemeColor, pinkGradientColor]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Rectangle()
                .fill(Color.white.opacity(0.9))
        }
    }
    
    var restoreView: some View {
        HStack {
            Button {
                premiumManager.restorePurchases { success, error in
                    if success {
                        showRestoreSuccess = true
                    } else {
                        purchaseErrorMessage = error ?? "Restore failed."
                        showPurchaseError = true
                    }
                }
            } label: {
                Text("Restore")
                    .font(FontConstants.SyneFonts.medium(size: 20))
                    .foregroundStyle(Color.black.opacity(0.5))
            }
            Spacer()
            Button {
                AdManager.shared.showInterstitialAd()
                isTabBarHidden = isHideTabBackPremium
                navigationPath.removeLast()
            } label: {
                Image("ic_close")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 30, height: 30)
        }
        .padding(.top)
    }
    
    var headerView: some View {
        VStack(spacing: 10) {
            Text("Unlock Premium")
                .font(FontConstants.SyneFonts.semiBold(size: 35))
                .overlay(
                    LinearGradient(colors: [redThemeColor, pinkGradientColor],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .mask(
                    Text("Unlock Premium")
                        .font(FontConstants.SyneFonts.semiBold(size: 35))
                )
            
            Text("access now")
                .font(FontConstants.SyneFonts.semiBold(size: 25))
                .foregroundStyle(.black)
        }
    }
    
    var featuresView: some View {
        VStack(spacing: 16) {
            featureView(text: "HD Quality")
            featureView(text: "Ads Free 100%")
            featureView(text: "Unlimited all Access")
            featureView(text: "High Speed Connectivity")
        }
    }
    
    func featureView(text: String) -> some View {
        HStack {
            Image("ic_check")
            Text(text)
                .font(FontConstants.SyneFonts.medium(size: 17))
            Spacer()
        }
    }
    
    var subscriptionPlansView: some View {
        VStack(spacing: 10) {
            ForEach(Array(premiumManager.products.enumerated()), id: \.element.productIdentifier) { index, product in
                Button {
                    AdManager.shared.showInterstitialAd()
                    selectedPlanIndex = index
                } label: {
                    SubscriptionPlanCell(
                        product: product,
                        isSelected: selectedPlanIndex == index
                    )
                }
            }
        }
    }
    
    var getFullAccessButton: some View {
        Button {
            guard premiumManager.products.indices.contains(selectedPlanIndex) else { return }
            let product = premiumManager.products[selectedPlanIndex]
            
            isPurchasing = true
            premiumManager.purchase(product: product) { success, error in
                isPurchasing = false
                if success {
                    showPurchaseSuccess = true
                } else {
                    purchaseErrorMessage = error ?? "Purchase failed."
                    showPurchaseError = true
                }
            }
        } label: {
            Text("Get Full Access")
                .font(FontConstants.MontserratFonts.bold(size: 17))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [redThemeColor, pinkGradientColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
        }
        .disabled(isPurchasing || premiumManager.isLoadingProducts)
    }
    
    var footerView: some View {
        HStack(spacing: 0) {
            Button {
                if let url = privacyPolicy {
                    openURL(url)
                }
            } label: { Text("▪︎  Privacy & Policy") }
            Spacer()
            Button {
                if let url = termsCondition {
                    openURL(url)
                }
            } label: { Text("▪︎  Terms & Condition") }
            Spacer()
            Button {
                if let url = EULA {
                    openURL(url)
                }
            } label: { Text("▪︎  EULA") }
        }
        .font(FontConstants.SyneFonts.light(size: 14))
        .foregroundStyle(.black)
    }
}

struct SubscriptionPlanCell: View {
    let product: StoreProduct
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(product.localizedPriceString)/ \(product.sk2Product?.description ?? "")")
                    .font(FontConstants.MontserratFonts.semiBold(size: 18))
                    .foregroundStyle(isSelected ? .white : .black)
                Text(product.localizedTitle)
                    .font(isSelected ?
                          FontConstants.MontserratFonts.semiBold(size: 17) :
                            FontConstants.MontserratFonts.medium(size: 17))
                    .foregroundStyle(isSelected ? .white.opacity(0.7) : textGrayColor.opacity(0.7))
            }
            Spacer()
            Image("ic_circle_fill")
        }
        .padding()
        .background(
            isSelected ?
            AnyView(
                LinearGradient(
                    gradient: Gradient(colors: [redThemeColor, pinkGradientColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ) :
                AnyView(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(textGrayColor.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(15)
    }
}

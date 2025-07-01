//
//  PhotoLibraryEditionApp.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI
import SwiftData
import IQKeyboardManagerSwift
import Firebase
import GoogleMobileAds

@main
struct PhotoLibraryEditionApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var adManager = AdManager.shared
    
    init() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistance = 10
        
        FirebaseApp.configure()
        AdServices().fetchNewRemoteAdsData { response in
            if let appOpenAdUnitID = response.appOpen {
                AdManager.shared.appOpenAdUnitID = appOpenAdUnitID
                if !PremiumManager.shared.isPremium {
                    AdManager.shared.loadAppOpenAd(true)
                }
            }
            
            if let bannerAdUnitID = response.banner {
                AdManager.shared.bannerAdUnitID = bannerAdUnitID
            }
            
        } failure: { error in
            print("error remote config fetch: \(error)")
        }
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Collage.self,
            HidePhotoModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .onAppear {
                    if !PremiumManager.shared.isPremium {
                        showAppOpenAd()
                        showBannerAd()
                    }
                }
                .onReceive(adManager.$isAppOpenAdReady) { isReady in
                    if isReady && !PremiumManager.shared.isPremium {
                        showAppOpenAd()
                        showBannerAd()
                    }
                }
                .onChange(of: scenePhase) { oldValue, newValue in
                    if newValue == .active && !PremiumManager.shared.isPremium {
                        showAppOpenAd()
                        showBannerAd()
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    func showAppOpenAd() {
        AdManager.shared.showAppOpenAdIfAvailable(from: UIApplication.shared.rootVC)
    }
    
    func showBannerAd() {
        AdManager.shared.loadBannerAd(rootViewController: UIApplication.shared.rootVC)
    }
}

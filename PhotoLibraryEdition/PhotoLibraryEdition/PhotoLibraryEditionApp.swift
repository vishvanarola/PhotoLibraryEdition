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
import AppTrackingTransparency
import AdSupport

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
            interstitialIntergap = response.intergap ?? 3
            if let appOpenAdUnitID = response.appOpen {
                AdManager.shared.appOpenAdUnitID = appOpenAdUnitID
                if !PremiumManager.shared.isPremium {
                    AdManager.shared.loadAppOpenAd(true)
                }
            }
            
            if let bannerAdUnitID = response.banner {
                AdManager.shared.bannerAdUnitID = bannerAdUnitID
            }
            
            if let interstitialAdUnitID = response.interstitial {
                AdManager.shared.interstitialAdUnitID = interstitialAdUnitID
                AdManager.shared.loadInterstitialAd()
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
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        requestPermission()
                    }
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
        AdManager.shared.showAppOpenAdIfAvailable()
    }
    
    func showBannerAd() {
        AdManager.shared.loadBannerAd()
    }
    
    func requestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Authorized")
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    print("Denied")
                case .notDetermined:
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
}

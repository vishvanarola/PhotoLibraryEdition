//
//  AdManager.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 01/07/25.
//

import GoogleMobileAds

class AdManager: NSObject, ObservableObject {
    static let shared = AdManager()
    
    @Published var isAppOpenAdReady = false
    
    // MARK: App Open Ad Properties
    var appOpenAd: AppOpenAd?
    var appOpenAdUnitID: String = ""
    
    // MARK: Banner Ad Properties
    var bannerView: BannerView?
    var bannerAdUnitID: String = ""
    
    // MARK: Interstitial Ad Properties
    var interstitialAd: InterstitialAd?
    var interstitialAdUnitID: String = ""
    
    // MARK: App Open Ad Methods
    func loadAppOpenAd(_ isShowAd: Bool) {
        guard !appOpenAdUnitID.isEmpty else {
            print("App Open Ad unit ID is empty.")
            return
        }
        
        AppOpenAd.load(with: appOpenAdUnitID, request: Request()) { [weak self] ad, error in
            if let error = error {
                print("Failed to load App Open Ad: \(error.localizedDescription)")
                self?.isAppOpenAdReady = false
                return
            }
            
            self?.appOpenAd = ad
            self?.appOpenAd?.fullScreenContentDelegate = self
            if isShowAd {
                self?.isAppOpenAdReady = true
            }
            print("App Open Ad loaded successfully.")
        }
    }
    
    func showAppOpenAdIfAvailable() {
        if let ad = appOpenAd {
            ad.present(from: UIApplication.shared.rootVC)
            isAppOpenAdReady = false
            loadAppOpenAd(false)
        } else {
            print("App Open Ad not ready. Triggering load.")
            loadAppOpenAd(true)
        }
    }
    
    // MARK: Banner Ad Methods
    func loadBannerAd( adSize: AdSize = AdSizeBanner) {
        guard !bannerAdUnitID.isEmpty else {
            print("Banner Ad unit ID is empty.")
            return
        }
        bannerView = BannerView(adSize: adSize)
        bannerView?.adUnitID = bannerAdUnitID
        bannerView?.rootViewController = UIApplication.shared.rootVC
        bannerView?.load(Request())
        print("Banner Ad loading...")
    }
    
    // MARK: Interstitial Ad Methods
    func loadInterstitialAd() {
        guard !interstitialAdUnitID.isEmpty else {
            print("Interstitial Ad unit ID is empty.")
            return
        }
        
        InterstitialAd.load(with: interstitialAdUnitID, request: Request()) { [weak self] ad, error in
            if let error = error {
                print("Failed to load Interstitial Ad: \(error.localizedDescription)")
                self?.interstitialAd = nil
                return
            }
            
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            print("Interstitial Ad loaded successfully.")
        }
    }
    
    func showInterstitialAd() {
        if interstitialIntergap == 3 {
            if let interstitialAd = interstitialAd {
                interstitialAd.present(from: UIApplication.shared.rootVC)
                interstitialIntergap -= 1
                loadInterstitialAd()
                loadBannerAd()
            } else {
                print("Interstitial Ad is not ready. Loading a new one.")
                loadInterstitialAd()
            }
        } else {
            interstitialIntergap = interstitialIntergap <= 0 ? 3 : interstitialIntergap-1
        }
    }
}

// MARK: - FullScreenContentDelegate
extension AdManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("App Open Ad dismissed. Loading next one.")
        if appOpenAd == nil {
            print("app open ad is nil and load again")
            loadAppOpenAd(false)
        }
        if interstitialAd == nil {
            print("interstitial ad is nil and load again")
            loadInterstitialAd()
        }
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present: \(error.localizedDescription)")
        
        if appOpenAd == nil {
            print("app open ad is nil and load again")
            loadAppOpenAd(false)
        }
        if interstitialAd == nil {
            print("interstitial ad is nil and load again")
            loadInterstitialAd()
        }
    }
}

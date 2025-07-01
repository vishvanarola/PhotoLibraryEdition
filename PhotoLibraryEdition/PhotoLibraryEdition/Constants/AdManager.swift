//
//  AdManager.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 01/07/25.
//

import GoogleMobileAds

class AdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    static let shared = AdManager()
    
    @Published var isAppOpenAdReady = false
    
    // MARK: App Open Ad Properties
    var appOpenAd: AppOpenAd?
    var appOpenAdUnitID: String = ""
    
    // MARK: Banner Ad Properties
    var bannerView: BannerView?
    var bannerAdUnitID: String = ""
    
    // MARK: App Open Ad Methods
    func loadAppOpenAd(_ isOpenAd: Bool) {
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
            if isOpenAd {
                self?.isAppOpenAdReady = true
            }
            print("App Open Ad loaded successfully.")
        }
    }
    
    func showAppOpenAdIfAvailable(from rootViewController: UIViewController?) {
        if let ad = appOpenAd {
            ad.present(from: rootViewController)
            isAppOpenAdReady = false
            appOpenAd = nil
        } else {
            print("App Open Ad not ready. Triggering load.")
            loadAppOpenAd(true)
        }
    }
    
    // MARK: - GADFullScreenContentDelegate
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("App Open Ad dismissed. Loading next one.")
        loadAppOpenAd(false)
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present App Open Ad: \(error.localizedDescription)")
        loadAppOpenAd(false)
    }
    
    // MARK: Banner Ad Methods
    func loadBannerAd(rootViewController: UIViewController?, adSize: AdSize = AdSizeBanner) {
        guard !bannerAdUnitID.isEmpty else {
            print("Banner Ad unit ID is empty.")
            return
        }
        bannerView = BannerView(adSize: adSize)
        bannerView?.adUnitID = bannerAdUnitID
        bannerView?.rootViewController = rootViewController
        bannerView?.load(Request())
        print("Banner Ad loading...")
    }
}

//
//  BannerAdRepresentableView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 01/07/25.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = AdManager.shared.bannerAdUnitID
        bannerView.rootViewController = UIApplication.shared.rootVC
        bannerView.load(Request())
        return bannerView
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        
    }
}

extension UIApplication {
    var rootVC: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: { $0.isKeyWindow })?.rootViewController
    }
}

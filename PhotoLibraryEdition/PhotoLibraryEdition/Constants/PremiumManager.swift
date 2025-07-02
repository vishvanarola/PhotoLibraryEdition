//
//  PremiumManager.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 27/06/25.
//

import Foundation
import RevenueCat
import Combine

enum PremiumFeature: String, CaseIterable {
    case textRepeat
    case textToEmoji
    case textStyleDesign
    case muteAudio
    case videoConverter
    case createCollage
    case addPhotosInCollage
    case addPhotosInHide
}

class PremiumManager: ObservableObject {
    static let shared = PremiumManager()

    private let premiumKey = "isPremiumUser"
    private let usagePrefix = "featureUsed_"
    private let userDefaults = UserDefaults.standard
    
    private let entitlementIdentifier = "premium_access"
    
    @Published var products: [StoreProduct] = []
    @Published var isLoadingProducts = false
    @Published var purchaseInProgress = false
    @Published var purchaseError: String?
    
    var isPremium: Bool {
        get { userDefaults.bool(forKey: premiumKey) }
        set { userDefaults.set(newValue, forKey: premiumKey) }
    }
    
    private init() {}
    
    func configureRevenueCat() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_jRHlDNzsihlmwrJknwABegaBXoP")
        fetchProducts()
        checkPremiumStatus()
    }
    
    func fetchProducts() {
        isLoadingProducts = true
        
        Purchases.shared.getOfferings { offerings, error in
            DispatchQueue.main.async {
                if let products = offerings?.current?.availablePackages.map(\.storeProduct) {
                    self.products = products
                } else {
                    self.products = []
                }
                self.isLoadingProducts = false
            }
        }
    }
    
    func purchase(product: StoreProduct, completion: @escaping (Bool, String?) -> Void) {
        purchaseInProgress = true
        Purchases.shared.purchase(product: product) { (transaction, customerInfo, error, userCancelled) in
            DispatchQueue.main.async {
                self.purchaseInProgress = false
                if let error = error, !userCancelled {
                    self.purchaseError = error.localizedDescription
                    completion(false, error.localizedDescription)
                    return
                }
                
                if let customerInfo = customerInfo,
                   customerInfo.entitlements[self.entitlementIdentifier]?.isActive == true {
                    self.setPremium(true)
                    completion(true, nil)
                } else {
                    completion(false, "Purchase failed")
                }
            }
        }
    }
    
    func restorePurchases(completion: @escaping (Bool, String?) -> Void) {
        Purchases.shared.restorePurchases { customerInfo, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                
                if let customerInfo = customerInfo,
                   customerInfo.entitlements[self.entitlementIdentifier]?.isActive == true {
                    self.setPremium(true)
                    completion(true, nil)
                } else {
                    completion(false, "No active subscription found")
                }
            }
        }
    }
    
    // Check if user is premium
    func checkPremiumStatus() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            DispatchQueue.main.async {
                if let customerInfo = customerInfo,
                   customerInfo.entitlements[self.entitlementIdentifier]?.isActive == true {
                    self.setPremium(true)
                } else {
                    self.setPremium(false)
                }
            }
        }
    }
    
    // Check if feature has been used
    func hasUsed(feature: PremiumFeature) -> Bool {
        return userDefaults.bool(forKey: usagePrefix + feature.rawValue)
    }
    
    // Mark feature as used
    func markUsed(feature: PremiumFeature) {
        userDefaults.set(true, forKey: usagePrefix + feature.rawValue)
    }
    
    // Reset all usages (for testing or logout)
    func resetAllUsages() {
        for feature in PremiumFeature.allCases {
            userDefaults.removeObject(forKey: usagePrefix + feature.rawValue)
        }
    }
    
    // Set user as premium
    func setPremium(_ value: Bool) {
        isPremium = value
    }
}

//
//  PremiumManager.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 27/06/25.
//

import Foundation
import RevenueCat
import Combine

class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    private let premiumKey = "isPremiumUser"
    private let isFeatureUserd = "isFeatureUserd"
    private let userDefaults = UserDefaults.standard
    
    private let entitlementIdentifier = "Pro"
    
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
    func hasUsed() -> Bool {
        return userDefaults.bool(forKey: isFeatureUserd)
    }
    
    // Mark feature as used
    func markUsed() {
        userDefaults.set(true, forKey: isFeatureUserd)
    }
    
    // Reset all usages (for testing or logout)
    func resetAllUsages() {
        userDefaults.removeObject(forKey: isFeatureUserd)
    }
    
    // Set user as premium
    func setPremium(_ value: Bool) {
        isPremium = value
    }
}

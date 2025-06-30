//
//  PremiumManager.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 27/06/25.
//

import Foundation

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

class PremiumManager {
    static let shared = PremiumManager()
    private let premiumKey = "isPremiumUser"
    private let usagePrefix = "featureUsed_"
    private let userDefaults = UserDefaults.standard
    
    // Check if user is premium
    var isPremium: Bool {
        get { userDefaults.bool(forKey: premiumKey) }
        set { userDefaults.set(newValue, forKey: premiumKey) }
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

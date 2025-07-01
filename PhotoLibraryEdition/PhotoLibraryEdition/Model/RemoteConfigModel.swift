//
//  RemoteConfigModel.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 01/07/25.
//

import Foundation

struct RemoteAdsModel : Codable {
    var appOpen : String? = nil
    var banner : String? = nil
    var interstitial : String? = nil
    var native : String? = nil
    var rewardedInterstitial : String? = nil
    var intergap : Int? = nil
    
    init() {
        
    }
}

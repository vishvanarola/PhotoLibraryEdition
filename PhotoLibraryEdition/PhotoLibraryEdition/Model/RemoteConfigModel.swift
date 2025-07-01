//
//  RemoteConfigModel.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 01/07/25.
//

import Foundation

struct RemoteConfigModel : Codable {
    let appOpen : String?
    let banner : String?
    let interstitial : String?
    let native : String?
    let rewardedInterstitial : String?
    let intergap : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case appOpen = "appOpen"
        case banner = "banner"
        case interstitial = "interstitial"
        case native = "native"
        case rewardedInterstitial = "rewardedInterstitial"
        case intergap = "Intergap"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        appOpen = try values.decodeIfPresent(String.self, forKey: .appOpen)
        banner = try values.decodeIfPresent(String.self, forKey: .banner)
        interstitial = try values.decodeIfPresent(String.self, forKey: .interstitial)
        native = try values.decodeIfPresent(String.self, forKey: .native)
        rewardedInterstitial = try values.decodeIfPresent(String.self, forKey: .rewardedInterstitial)
        intergap = try values.decodeIfPresent(Int.self, forKey: .intergap)
    }
    
}

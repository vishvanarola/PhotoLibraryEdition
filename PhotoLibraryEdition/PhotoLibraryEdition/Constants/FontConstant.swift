//
//  FontConstant.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI

struct FontConstants {
    
    // MARK: - Font Families
    struct Family {
        static let light = "Montserrat-Light"
        static let regular = "Montserrat-Regular"
        static let medium = "Montserrat-Medium"
        static let semibold = "Montserrat-SemiBold"
        static let bold = "Montserrat-Bold"
    }
    
    // MARK: - Dynamic Font Provider
    struct Fonts {
        static func montserrat_Light(size: CGFloat) -> Font {
            Font.custom(Family.light, size: size)
        }
        
        static func montserrat_Regular(size: CGFloat) -> Font {
            Font.custom(Family.regular, size: size)
        }
        
        static func montserrat_Medium(size: CGFloat) -> Font {
            Font.custom(Family.medium, size: size)
        }
        
        static func montserrat_SemiBold(size: CGFloat) -> Font {
            Font.custom(Family.semibold, size: size)
        }
        
        static func montserrat_Bold(size: CGFloat) -> Font {
            Font.custom(Family.bold, size: size)
        }
    }
}

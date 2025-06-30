//
//  HidePhotoModel.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 29/06/25.
//

import Foundation
import SwiftData

@Model
final class HidePhotoModel {
    var id: UUID
    var data: Data
    
    init(data: Data) {
        self.id = UUID()
        self.data = data
    }
}

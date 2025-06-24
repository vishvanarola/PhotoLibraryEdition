//
//  CollageModel.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 24/06/25.
//

import Foundation
import SwiftData

@Model
final class Collage {
    var id: UUID
    var name: String
    var createdAt: Date
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}

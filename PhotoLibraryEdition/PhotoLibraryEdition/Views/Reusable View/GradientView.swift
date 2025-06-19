//
//  GradientView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI

struct GradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 229/255, green: 32/255, blue: 32/255), Color(red: 1.0, green: 65/255, blue: 101/255)]),
            startPoint: .leading,
            endPoint: .trailing
        )
//        .ignoresSafeArea()
    }
}

#Preview {
    GradientView()
}

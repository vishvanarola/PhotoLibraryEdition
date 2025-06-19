//
//  SplashView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack(spacing: 15) {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.primary)
                
                Text("App Name")
                    .font(FontConstants.Fonts.montserrat_Bold(size: 30))
                    .foregroundColor(.primary)
                
                Text("Slow it down, create your space, and keep your moments private")
                    .font(FontConstants.Fonts.montserrat_Regular(size: 20))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

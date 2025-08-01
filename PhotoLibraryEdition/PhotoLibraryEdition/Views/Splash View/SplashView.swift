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
            TabBarView()
        } else {
            VStack(spacing: 15) {
                Image("ic_appicon")
                    .resizable()
                    .frame(width: 130, height: 130)
                    .foregroundColor(.primary)
                
                Text(splashAppName)
                    .font(FontConstants.SyneFonts.semiBold(size: 30))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("\"Slow it down, create your space, and keep your moments private.\"")
                    .font(FontConstants.MontserratFonts.regular(size: 20))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
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

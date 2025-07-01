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
                Image("ic_myfiles")
                    .resizable()
                    .frame(width: 130, height: 130)
                    .foregroundColor(.primary)
                
                Text(appName)
                    .font(FontConstants.SyneFonts.semiBold(size: 30))
                    .foregroundColor(.primary)
                
                Text("\"Slow it down, create your space, and keep your moments private.\"")
                    .font(FontConstants.MontserratFonts.regular(size: 20))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
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

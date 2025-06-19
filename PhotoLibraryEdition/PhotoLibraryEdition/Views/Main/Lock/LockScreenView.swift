//
//  LockScreenView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI

struct LockScreenView: View {
    var body: some View {
        VStack {
            Image(systemName: "lock.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            Text("Lock Screen")
                .font(.largeTitle)
                .padding()
        }
    }
}

#Preview {
    LockScreenView()
} 

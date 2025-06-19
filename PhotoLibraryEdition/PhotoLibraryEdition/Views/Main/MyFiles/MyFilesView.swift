//
//  MyFilesView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI

struct MyFilesView: View {
    var body: some View {
        VStack {
            Image(systemName: "folder.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            Text("My Files")
                .font(.largeTitle)
                .padding()
        }
    }
}

#Preview {
    MyFilesView()
} 

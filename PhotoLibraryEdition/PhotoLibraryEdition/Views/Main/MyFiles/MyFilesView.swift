//
//  MyFilesView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI

struct MyFilesView: View {
    @State private var showCreateCollage = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                listView
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            
            if showCreateCollage {
                CreateCollageView(isPresented: $showCreateCollage)
            }
        }
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: "ic_plus",
            headerTitle: "My Files",
            leftButtonAction: {
                dismiss()
            },
            rightButtonAction: {
                withAnimation {
                    showCreateCollage = true
                }
            }
        )
    }
    
    var listView: some View {
        HStack {
            Image("ic_folder")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading)
            Text("Gallery Photos")
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundStyle(Color.black)
            Spacer()
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(textGrayColor.opacity(0.10))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

#Preview {
    MyFilesView()
} 

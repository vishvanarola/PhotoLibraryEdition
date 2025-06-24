//
//  CreateCollageView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 24/06/25.
//

import SwiftUI

struct CreateCollageView: View {
    @State var previewText: String = ""
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create a Collage")
                .font(FontConstants.MontserratFonts.medium(size: 24))
                .foregroundStyle(Color.black)
            
            TextField("", text: $previewText, prompt: Text("Name..")
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundColor(.gray)
            )
            .font(FontConstants.MontserratFonts.semiBold(size: 18))
            .keyboardType(.default)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Text("Cancel")
                        .font(FontConstants.MontserratFonts.medium(size: 20))
                        .foregroundStyle(Color.black)
                }
                Spacer()
                Divider()
                    .frame(width: 1, height: 40)
                    .background(textGrayColor)
                Spacer()
                Button {
                    
                } label: {
                    Text("Create")
                        .font(FontConstants.MontserratFonts.medium(size: 20))
                        .foregroundStyle(Color.black)
                }
                Spacer()
            }
            .frame(height: 35)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity)
        .background(pinkOpacityColor.opacity(0.06))
        .cornerRadius(20)
        .padding(.horizontal, 45)
    }
}

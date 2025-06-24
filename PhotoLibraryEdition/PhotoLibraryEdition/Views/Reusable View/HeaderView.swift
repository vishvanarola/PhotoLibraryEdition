//
//  HeaderView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 21/06/25.
//

import SwiftUI

struct HeaderView: View {
    let leftButtonImageName: String
    let rightButtonImageName: String?
    let headerTitle: String
    let leftButtonAction: () -> Void
    let rightButtonAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            GradientView()
            VStack {
                 Spacer()
                 HStack {
                     Button {
                         leftButtonAction()
                     } label: {
                         Image(leftButtonImageName)
                             .foregroundColor(.white)
                     }
                     Spacer()
                     if (rightButtonImageName == nil) {
                         Spacer()
                     }
                     Text(headerTitle)
                         .font(FontConstants.SyneFonts.semiBold(size: 23))
                         .foregroundStyle(Color.white)
                     Spacer()
                     if let rightImage = rightButtonImageName {
                         Button(action: {
                             rightButtonAction?()
                         }) {
                             Image(rightImage)
                                 .foregroundColor(.white)
                         }
                     } else {
                         Spacer()
                         Spacer()
                     }
                 }
                 .padding(.bottom, 20)
                 .padding(.horizontal, 20)
             }
        }
        .frame(height: UIScreen.main.bounds.height * 0.15)
    }
}

#Preview {
    HeaderView(
        leftButtonImageName: "ic_back",
        rightButtonImageName: nil,
        headerTitle: "Text Repeater",
        leftButtonAction: {
            print("Back button tapped")
        },
        rightButtonAction: nil
    )
}

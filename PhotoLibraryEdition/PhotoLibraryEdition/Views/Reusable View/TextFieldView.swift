//
//  TextFieldView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 21/06/25.
//

import SwiftUI

struct TextFieldView: View {
    let headerTitle: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isEmoji: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(headerTitle)
                .font(FontConstants.MontserratFonts.medium(size: 20))
                .foregroundStyle(textGrayColor)
            
            TextField("", text: $text, prompt: Text(placeholder)
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundColor(.gray)
            )
            .font(FontConstants.MontserratFonts.semiBold(size: 18))
            .keyboardType(keyboardType)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(redThemeColor, lineWidth: 1)
            )
            .background(pinkThemeColor.opacity(0.05))
            .onChange(of: text) { oldValue, newValue in
                if isEmoji {
                    let filtered = newValue.filter { $0.isEmoji }
                    if filtered != newValue {
                        text = filtered
                    }
                }
            }
        }
    }
}

extension Character {
    var isEmoji: Bool {
        return unicodeScalars.first?.properties.isEmojiPresentation == true ||
               unicodeScalars.contains { $0.properties.isEmoji }
    }
}

#Preview {
    TextFieldView(
        headerTitle: "Username",
        placeholder: "Enter your username",
        text: .constant(""),
        keyboardType: .default
    )
}

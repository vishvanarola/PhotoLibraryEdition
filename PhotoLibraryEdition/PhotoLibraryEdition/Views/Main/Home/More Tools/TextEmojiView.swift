//
//  TextEmojiView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 20/06/25.
//

import SwiftUI

struct TextEmojiView: View {
    @State private var enterTextInput: String = ""
    @State private var emojiInput: String = ""
    @State private var outputText: String = ""
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            headerView
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    enterTextView
                    enterEmojiView
                    outputTextView
                }
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
            outputButton
        }
        .ignoresSafeArea()
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: nil,
            headerTitle: "Text to Emoji",
            leftButtonAction: {
                isTabBarHidden = false
                navigationPath.removeLast()
            },
            rightButtonAction: nil
        )
    }
    
    var enterTextView: some View {
        TextFieldView(headerTitle: "Enter Text", placeholder: "Enter text here", text: $enterTextInput)
    }
    
    var enterEmojiView: some View {
        TextFieldView(headerTitle: "Enter Emoji", placeholder: "E.g. 🤩", text: $emojiInput, keyboardType: .default, isEmoji: true)
    }
    
    var outputTextView: some View {
        TextEditor(text: $outputText)
            .scrollContentBackground(.hidden)
            .font(FontConstants.MontserratFonts.medium(size: 18))
            .foregroundStyle(.black)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(10)
            .frame(height: 250)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(redThemeColor, lineWidth: 1)
            )
            .background(pinkThemeColor.opacity(0.05))
    }
    
    var outputButton: some View {
        Button {
            generateEmojiText()
        } label: {
            Text("Generate Emoji")
                .font(FontConstants.MontserratFonts.semiBold(size: 22))
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(redThemeColor)
                .cornerRadius(10)
        }
        .padding(.bottom)
        .padding(.horizontal, 20)
    }
    
    private func generateEmojiText() {
        outputText = emojiPattern(for: enterTextInput, e: emojiInput)
    }
    
    func emojiPattern(for letter: String, e: String) -> String {
        guard !e.isEmpty else { return "" }
        PremiumManager.shared.markUsed(feature: PremiumFeature.textToEmoji)
        
        switch letter.uppercased() {
        case "A":
            return """
              \(e)\(e)
             \(e)  \(e)
            \(e)\(e)\(e)
            \(e)     \(e)
            \(e)     \(e)
            """
        case "B":
            return """
            \(e)\(e)
            \(e)  \(e)
            \(e)\(e)
            \(e)  \(e)
            \(e)\(e)
            """
        case "C":
            return """
             \(e)\(e)\(e)
            \(e)
            \(e)
            \(e)
             \(e)\(e)\(e)
            """
        case "D":
            return """
            \(e)\(e)
            \(e)  \(e)
            \(e)   \(e)
            \(e)  \(e)
            \(e)\(e)
            """
        case "E":
            return """
            \(e)\(e)\(e)
            \(e)
            \(e)\(e)
            \(e)
            \(e)\(e)\(e)
            """
        case "F":
            return """
            \(e)\(e)\(e)
            \(e)
            \(e)\(e)
            \(e)
            \(e)
            """
        case "G":
            return """
             \(e)\(e)\(e)
            \(e)
            \(e) \(e)\(e)
            \(e)   \(e)
             \(e)\(e)\(e)
            """
        case "H":
            return """
            \(e)     \(e)
            \(e)     \(e)
            \(e)\(e)\(e)
            \(e)     \(e)
            \(e)     \(e)
            """
        case "I":
            return """
            \(e)\(e)\(e)
                \(e)
                \(e)
                \(e)
            \(e)\(e)\(e)
            """
        case "J":
            return """
             \(e)\(e)\(e)\(e)
                    \(e)
                    \(e)
            \(e)   \(e)
              \(e)\(e)
            """
        case "K":
            return """
            \(e)  \(e)
            \(e) \(e)
            \(e)
            \(e) \(e)
            \(e)  \(e)
            """
        case "L":
            return """
            \(e)
            \(e)
            \(e)
            \(e)
            \(e)\(e)\(e)
            """
        case "M":
            return """
            \(e)         \(e)
            \(e)\(e)\(e)\(e)
            \(e)  \(e)   \(e)
            \(e)          \(e)
            \(e)          \(e)
            """
        case "N":
            return """
              \(e)    \(e)
            \(e)\(e)  \(e)
            \(e) \(e) \(e)
            \(e)  \(e)\(e)
            \(e)    \(e)
            """
        case "O":
            return """
             \(e)\(e)\(e)
            \(e)       \(e)
            \(e)       \(e)
            \(e)       \(e)
             \(e)\(e)\(e)
            """
        case "P":
            return """
            \(e)\(e)\(e)
            \(e)    \(e)
            \(e)\(e)\(e)
            \(e)
            \(e)
            """
        case "Q":
            return """
             \(e)\(e)\(e)
            \(e)       \(e)
            \(e)       \(e)
            \(e)    \(e)\(e)
             \(e)\(e)\(e)\(e)
                               \(e)
            """
        case "R":
            return """
            \(e)\(e)\(e)
            \(e)     \(e)
            \(e)\(e)\(e)
            \(e)   \(e)
            \(e)     \(e)
            """
        case "S":
            return """
              \(e)\(e)\(e)
            \(e)
              \(e)\(e)\(e)
                        \(e)
             \(e)\(e)\(e)
            """
        case "T":
            return """
            \(e)\(e)\(e)
                \(e)
                \(e)
                \(e)
                \(e)
            """
        case "U":
            return """
            \(e)    \(e)
            \(e)    \(e)
            \(e)    \(e)
            \(e)    \(e)
              \(e)\(e)
            """
        case "V":
            return """
            \(e)      \(e)
             \(e)    \(e)
              \(e)  \(e)
               \(e)\(e)
                 \(e)
            """
        case "W":
            return """
            \(e)                 \(e)
             \(e)               \(e)
              \(e)    \(e)    \(e)
               \(e)\(e) \(e)\(e)
                 \(e)     \(e)
            """
        case "X":
            return """
            \(e)    \(e)
             \(e) \(e)
                \(e)
             \(e) \(e)
            \(e)    \(e)
            """
        case "Y":
            return """
            \(e)      \(e)
              \(e)  \(e)
                 \(e)
                 \(e)
                 \(e)
            """
        case "Z":
            return """
            \(e)\(e)\(e)
                  \(e)
                \(e)
             \(e)
            \(e)\(e)\(e)
            """
        default:
            return "Pattern not available for this letter."
        }
    }
}

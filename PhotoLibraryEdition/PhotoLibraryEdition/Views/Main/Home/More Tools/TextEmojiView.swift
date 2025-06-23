//
//  TextEmojiView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 20/06/25.
//

import SwiftUI

struct TextEmojiView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var enterTextInput: String = ""
    @State private var emojiInput: String = ""
    @State private var outputText: String = ""
    
    var body: some View {
        VStack() {
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
                presentationMode.wrappedValue.dismiss()
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
        print(emojiPattern(for: enterTextInput, e: "🤓"))
//        generateEmojiArt(for: enterTextInput, emoji: "🤓")
    }
    
    func emojiPattern(for letter: String, e: String) -> String {
        guard !e.isEmpty else { return "" }

        switch letter.uppercased() {
        case "A":
            return """
              \(e)\(e)
             \(e)  \(e)
            \(e)\(e)\(e)\(e)
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
            \(e)   \(e)
            \(e)   \(e)
            \(e)\(e)\(e)
            \(e)   \(e)
            \(e)   \(e)
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
             \(e)\(e)\(e)
               \(e)
               \(e)
            \(e)  \(e)
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
            \(e)   \(e)
            \(e)\(e) \(e)\(e)
            \(e) \(e) \(e)
            \(e)   \(e)
            \(e)   \(e)
            """
        case "N":
            return """
            \(e)   \(e)
            \(e)\(e)  \(e)
            \(e) \(e) \(e)
            \(e)  \(e)\(e)
            \(e)   \(e)
            """
        case "O":
            return """
             \(e)\(e)\(e)
            \(e)   \(e)
            \(e)   \(e)
            \(e)   \(e)
             \(e)\(e)\(e)
            """
        case "P":
            return """
            \(e)\(e)\(e)
            \(e)   \(e)
            \(e)\(e)\(e)
            \(e)
            \(e)
            """
        case "Q":
            return """
             \(e)\(e)\(e)
            \(e)   \(e)
            \(e)   \(e)
            \(e) \(e) \(e)
             \(e)\(e)\(e) \(e)
            """
        case "R":
            return """
            \(e)\(e)\(e)
            \(e)   \(e)
            \(e)\(e)\(e)
            \(e)  \(e)
            \(e)   \(e)
            """
        case "S":
            return """
             \(e)\(e)\(e)
            \(e)
             \(e)\(e)
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
            \(e)   \(e)
            \(e)   \(e)
            \(e)   \(e)
            \(e)   \(e)
             \(e)\(e)\(e)
            """
        case "V":
            return """
            \(e)   \(e)
            \(e)   \(e)
            \(e)   \(e)
             \(e) \(e)
              \(e)
            """
        case "W":
            return """
            \(e)   \(e)
            \(e)   \(e)
            \(e) \(e) \(e)
            \(e)\(e) \(e)\(e)
            \(e)   \(e)
            """
        case "X":
            return """
            \(e)   \(e)
             \(e) \(e)
              \(e)
             \(e) \(e)
            \(e)   \(e)
            """
        case "Y":
            return """
            \(e)   \(e)
             \(e) \(e)
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
    
//    func generateEmojiArt(for character: String, emoji: String) -> String {
//        let size = CGSize(width: 40, height: 40)
//        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
//        let context = UIGraphicsGetCurrentContext()!
//        
//        // Set white background
//        context.setFillColor(UIColor.white.cgColor)
//        context.fill(CGRect(origin: .zero, size: size))
//        
//        // Draw character
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.systemFont(ofSize: 36),
//            .foregroundColor: UIColor.black
//        ]
//        let str = character
//        let textSize = str.size(withAttributes: attributes)
//        let rect = CGRect(x: (size.width - textSize.width) / 2,
//                          y: (size.height - textSize.height) / 2,
//                          width: textSize.width,
//                          height: textSize.height)
//        str.draw(in: rect, withAttributes: attributes)
//        
//        // Get image
//        let image = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        
//        guard let cgImage = image.cgImage else { return "Failed to generate image." }
//        let width = cgImage.width
//        let height = cgImage.height
//        guard let data = cgImage.dataProvider?.data else { return "Image data error" }
//        let ptr = CFDataGetBytePtr(data)
//        
//        var output = ""
//        
//        for y in stride(from: 0, to: height, by: 2) { // every second line for squished look
//            for x in stride(from: 0, to: width, by: 2) {
//                let pixelIndex = (y * cgImage.bytesPerRow) + (x * 4)
//                let r = ptr![pixelIndex]
//                let g = ptr![pixelIndex + 1]
//                let b = ptr![pixelIndex + 2]
//                
//                let brightness = 0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b)
//                output += (brightness < 128) ? emoji : " "
//            }
//            output += "\n"
//        }
//        print(output)
//        return output
//    }
}

#Preview {
    TextEmojiView()
}

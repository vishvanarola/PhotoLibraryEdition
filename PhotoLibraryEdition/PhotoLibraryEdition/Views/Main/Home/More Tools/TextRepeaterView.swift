//
//  TextRepeaterView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 20/06/25.
//

import SwiftUI

struct TextRepeaterView: View {
    @State private var enterTextInput: String = ""
    @State private var repeaterCountInput: String = ""
    @State private var isAddSpaceSelected: Bool = false
    @State private var isNewLineSelected: Bool = false
    @State private var outputText: String = ""
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            headerView
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    enterTextView
                    enterRepeaterView
                    checkBoxView
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
            headerTitle: "Text Repeater",
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
    
    var enterRepeaterView: some View {
        TextFieldView(headerTitle: "Enter Repeater", placeholder: "E.g. 3", text: $repeaterCountInput, keyboardType: .numberPad)
    }
    
    var checkBoxView: some View {
        HStack(spacing: 20) {
            Button {
                isAddSpaceSelected.toggle()
                if isAddSpaceSelected { isNewLineSelected = false }
            } label: {
                HStack {
                    Image(isAddSpaceSelected ? "ic_check_fill" : "ic_check_box")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("Add Space")
                        .font(FontConstants.MontserratFonts.medium(size: 20))
                        .foregroundStyle(.black)
                }
            }
            
            Button {
                isNewLineSelected.toggle()
                if isNewLineSelected { isAddSpaceSelected = false }
            } label: {
                HStack {
                    Image(isNewLineSelected ? "ic_check_fill" : "ic_check_box")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("New Line")
                        .font(FontConstants.MontserratFonts.medium(size: 20))
                        .foregroundStyle(.black)
                }
            }
        }
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
            generateRepeatedText()
        } label: {
            Text("Repeat")
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
    
    private func generateRepeatedText() {
        guard let count = Int(repeaterCountInput), count > 0, !enterTextInput.isEmpty else {
            outputText = "Please enter valid input."
            return
        }
        
        let separator: String
        if isAddSpaceSelected {
            separator = " "
        } else if isNewLineSelected {
            separator = "\n"
        } else {
            separator = ""
        }
        
        outputText = Array(repeating: enterTextInput, count: count).joined(separator: separator)
        PremiumManager.shared.markUsed(feature: PremiumFeature.textRepeat)
    }
}

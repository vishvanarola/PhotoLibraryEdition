//
//  ForgotPasswordView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 25/06/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var passwordFields: [String] = Array(repeating: "", count: 4)
    @State private var currentIndex: Int = 0
    @State var password: String = ""
    @State var confirmedPassword: String = ""
    @State var headingTitle: String = "Click here to reset it and regain access to your account."
    @State private var isConfirmingPassword: Bool = false
    @State private var showMismatchAlert: Bool = false
    @Binding var navigationPath: NavigationPath
    @Binding var isTabBarHidden: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            headerView
            ScrollView {
                forgotPasswordView
                passwordTextFieldView
                numberPad
            }
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .alert("Passwords do not match\nPlease set them again", isPresented: $showMismatchAlert) {
            Button("OK", role: .cancel) {
                resetAll()
            }
        }
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: nil,
            headerTitle: "Lock",
            leftButtonAction: {
                AdManager.shared.showInterstitialAd()
                isTabBarHidden = false
                navigationPath.removeLast()
            },
            rightButtonAction: nil
        )
    }
    
    var forgotPasswordView: some View {
        VStack(spacing: 10) {
            Text("Forgot Password?")
                .font(FontConstants.MontserratFonts.bold(size: 25))
                .overlay(
                    LinearGradient(
                        colors: [redThemeColor, pinkGradientColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .mask(
                    Text("Forgot Password?")
                        .font(FontConstants.MontserratFonts.bold(size: 25))
                )
            Text(headingTitle)
                .font(FontConstants.MontserratFonts.medium(size: 20))
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.center)
        }
    }
    
    var passwordTextFieldView: some View {
        HStack(spacing: 15) {
            ForEach(0..<4, id: \.self) { index in
                Text(passwordFields[index].isEmpty ? "" : passwordFields[index])
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(currentIndex == index ? redThemeColor : Color.black, lineWidth: currentIndex == index ? 1.5 : 1)
                    )
                    .font(.system(size: 24, weight: .bold))
                    .onTapGesture {
                        currentIndex = index
                    }
            }
        }
        .padding(.bottom)
        .onAppear {
            currentIndex = 0
        }
    }
    
    var numberPad: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                numberText(1) { numberTapped($0) }
                numberText(2) { numberTapped($0) }
                numberText(3) { numberTapped($0) }
            }
            HStack(spacing: 15) {
                numberText(4) { numberTapped($0) }
                numberText(5) { numberTapped($0) }
                numberText(6) { numberTapped($0) }
            }
            HStack(spacing: 15) {
                numberText(7) { numberTapped($0) }
                numberText(8) { numberTapped($0) }
                numberText(9) { numberTapped($0) }
            }
            HStack(spacing: 15) {
                Button {
                    AdManager.shared.showInterstitialAd()
                    cancelTapped()
                } label: {
                    Text("Cancel")
                        .font(FontConstants.MontserratFonts.medium(size: 18))
                        .foregroundStyle(Color.black)
                }
                numberText(0) { numberTapped($0) }
                Button {
                    AdManager.shared.showInterstitialAd()
                    doneTapped()
                } label: {
                    Text("Done")
                        .font(FontConstants.MontserratFonts.medium(size: 18))
                        .foregroundStyle(Color.black)
                }
            }
        }
    }
    
    func numberText(_ text: Int, action: @escaping (Int) -> Void) -> some View {
        Button {
            action(text)
        } label: {
            Text("\(text)")
                .font(FontConstants.MontserratFonts.medium(size: 25))
                .foregroundStyle(Color.black)
                .frame(width: 70, height: 70)
                .background(Color(red: 242/255, green: 84/255, blue: 91/255).opacity(0.1))
                .cornerRadius(15)
        }
    }
    
    func numberTapped(_ number: Int) {
        passwordFields[currentIndex] = "\(number)"
        
        if currentIndex < 3 {
            currentIndex += 1
        }
    }
    
    func cancelTapped() {
        resetAll()
    }
    
    func doneTapped() {
        let entered = passwordFields.joined()
        if entered.count < 4 { return }
        
        if !isConfirmingPassword {
            password = entered
            headingTitle = "Confirm your reseted four digit password"
            isConfirmingPassword = true
            resetPasswordFields()
        } else {
            confirmedPassword = entered
            if password == confirmedPassword {
                UserDefaults.standard.set(password, forKey: "userPassword")
                headingTitle = "Password set successfully"
                resetPasswordFields()
                print("✅ Password set successfully: \(password)")
                isTabBarHidden = false
                navigationPath.removeLast()
            } else {
                showMismatchAlert = true
                resetAll()
            }
        }
    }
    
    func resetPasswordFields() {
        passwordFields = Array(repeating: "", count: 4)
        currentIndex = 0
    }
    
    func resetAll() {
        password = ""
        confirmedPassword = ""
        isConfirmingPassword = false
        headingTitle = "Click here to reset it and regain access to your account."
        resetPasswordFields()
    }
    
    func resetPassword() {
        passwordFields = Array(repeating: "", count: 4)
        currentIndex = 0
        password = ""
    }
}

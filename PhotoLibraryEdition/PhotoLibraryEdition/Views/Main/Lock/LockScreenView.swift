//
//  LockScreenView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 19/06/25.
//

import SwiftUI

enum LockRoute: Hashable {
    case forgotPassword
    case hidePhotos
    case premium
}

struct LockScreenView: View {
    @Binding var selectedTab: CustomTab
    @State private var passwordFields: [String] = Array(repeating: "", count: 4)
    @State private var currentIndex: Int = 0
    @State var password: String = ""
    @State var confirmedPassword: String = ""
    @Binding var isTabBarHidden: Bool
    @State var headingTitle: String = "Set your four digit password"
    @State private var isConfirmingPassword: Bool = false
    @State private var showMismatchAlert: Bool = false
    @State private var isPasswordAlreadySet: Bool = false
    @State private var showWrongPasswordAlert: Bool = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                headerView
                ScrollView {
                    passwordView
                    passwordTextFieldView
                    numberPad
                    if let saved = UserDefaults.standard.string(forKey: "userPassword"), saved.isEmpty == false {
                        forgotPassButton
                    }
                }
                .padding(.horizontal, 20)
            }
            .onAppear {
                currentIndex = 0
                if let saved = UserDefaults.standard.string(forKey: "userPassword") {
                    isPasswordAlreadySet = !saved.isEmpty
                    headingTitle = "Enter your four digit password"
                }
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .alert("Passwords do not match\nPlease set them again", isPresented: $showMismatchAlert) {
                Button("OK", role: .cancel) {
                    resetAll()
                }
            }
            .alert("Incorrect Password", isPresented: $showWrongPasswordAlert) {
                Button("Try Again", role: .cancel) {
                    resetPasswordFields()
                }
            }
            .navigationDestination(for: LockRoute.self) { route in
                switch route {
                case .forgotPassword:
                    ForgotPasswordView(navigationPath: $navigationPath, isTabBarHidden: $isTabBarHidden)
                        .navigationBarBackButtonHidden(true)
                case .hidePhotos:
                    HidePhotoView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .premium:
                    PremiumView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: nil,
            headerTitle: "Lock",
            leftButtonAction: {
                withAnimation {
                    selectedTab = .home
                }
            },
            rightButtonAction: nil
        )
    }
    
    var passwordView: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Image("ic_lock_screen")
                Text("Password")
                    .font(FontConstants.MontserratFonts.semiBold(size: 25))
                    .foregroundStyle(Color.black)
            }
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
                    cancelTapped()
                } label: {
                    Text("Cancel")
                        .font(FontConstants.MontserratFonts.medium(size: 18))
                        .foregroundStyle(Color.black)
                }
                numberText(0) { numberTapped($0) }
                Button {
                    doneTapped()
                } label: {
                    Text("Done")
                        .font(FontConstants.MontserratFonts.medium(size: 18))
                        .foregroundStyle(Color.black)
                }
            }
        }
    }
    
    var forgotPassButton: some View {
        Button {
            isTabBarHidden = true
            navigationPath.append(LockRoute.forgotPassword)
        } label: {
            Text("Forgot Password?")
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundStyle(textGrayColor)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 100)
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
        
        if isPasswordAlreadySet {
            if entered == UserDefaults.standard.string(forKey: "userPassword") {
                print("✅ Password matched. Proceed to HidePhotoView")
                resetPasswordFields()
                isTabBarHidden = true
                if PremiumManager.shared.hasUsed(feature: PremiumFeature.addPhotosInHide) {
                    isHideTabBackPremium = false
                    navigationPath.append(LockRoute.premium)
                } else {
                    navigationPath.append(LockRoute.hidePhotos)
                }
            } else {
                showWrongPasswordAlert = true
                resetPasswordFields()
            }
        } else {
            if !isConfirmingPassword {
                password = entered
                headingTitle = "Confirm your four digit password"
                isConfirmingPassword = true
                resetPasswordFields()
            } else {
                confirmedPassword = entered
                if password == confirmedPassword {
                    UserDefaults.standard.set(password, forKey: "userPassword")
                    headingTitle = "Password set successfully"
                    resetPasswordFields()
                    isTabBarHidden = true
                    if PremiumManager.shared.hasUsed(feature: PremiumFeature.addPhotosInHide) {
                        isHideTabBackPremium = false
                        navigationPath.append(LockRoute.premium)
                    } else {
                        navigationPath.append(LockRoute.hidePhotos)
                    }
                    print("✅ Password set successfully: \(password)")
                } else {
                    showMismatchAlert = true
                    resetAll()
                }
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
        headingTitle = isPasswordAlreadySet ? "Enter your four digit password" : "Set your four digit password"
        resetPasswordFields()
    }
    
    func resetPassword() {
        passwordFields = Array(repeating: "", count: 4)
        currentIndex = 0
        password = ""
    }
}

#Preview {
    LockScreenView(selectedTab: .constant(.lock), isTabBarHidden: .constant(false))
}

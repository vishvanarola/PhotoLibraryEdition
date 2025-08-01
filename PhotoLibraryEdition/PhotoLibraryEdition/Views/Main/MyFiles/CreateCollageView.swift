//
//  CreateCollageView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 24/06/25.
//

import SwiftUI

struct CreateCollageView: View {
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isTextFieldFocused: Bool
    @State var collageName: String = ""
    @State private var showNoInternetAlert: Bool = false
    @Binding var isPresented: Bool
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    var collageToEdit: Collage?
    
    init(isPresented: Binding<Bool>, collageToEdit: Collage? = nil, isTabBarHidden: Binding<Bool>, navigationPath: Binding<NavigationPath>) {
        self._isPresented = isPresented
        self.collageToEdit = collageToEdit
        if let collage = collageToEdit {
            _collageName = State(initialValue: collage.name)
        }
        self._isTabBarHidden = isTabBarHidden
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(collageToEdit == nil ? "Create a Collage" : "Edit Collage")
                .font(FontConstants.MontserratFonts.medium(size: 24))
                .foregroundStyle(Color.black)
            
            TextField(
                "",
                text: $collageName,
                prompt: Text("Name..")
                    .font(FontConstants.MontserratFonts.medium(size: 18))
                    .foregroundColor(.gray)
            )
            .font(FontConstants.MontserratFonts.semiBold(size: 18))
            .keyboardType(.default)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .focused($isTextFieldFocused)
            
            HStack {
                Spacer()
                Button {
                    AdManager.shared.showInterstitialAd()
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
                    if ReachabilityManager.shared.isNetworkAvailable {
                        if PremiumManager.shared.isPremium || !PremiumManager.shared.hasUsed() {
                            AdManager.shared.showInterstitialAd()
                            if let collage = collageToEdit {
                                collage.name = collageName
                            } else {
                                let newCollage = Collage(name: collageName)
                                modelContext.insert(newCollage)
                            }
                            
                            do {
                                try modelContext.save()
                                PremiumManager.shared.markUsed()
                                withAnimation {
                                    isPresented = false
                                }
                            } catch {
                                print("Failed to save collage: \(error)")
                            }
                        } else {
                            isHideTabBackPremium = false
                            isTabBarHidden = true
                            navigationPath.append(MyFilesRoute.premium)
                        }
                    } else {
                        showNoInternetAlert = true
                    }
                } label: {
                    Text(collageToEdit == nil ? "Create" : "Save")
                        .font(FontConstants.MontserratFonts.medium(size: 20))
                        .foregroundStyle(collageName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .black)
                }
                .disabled(collageName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                Spacer()
            }
            .frame(height: 35)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity)
        .background(pinkOpacityColor.opacity(0.06))
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal, 45)
        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 0)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
        .noInternetAlert(isPresented: $showNoInternetAlert)
    }
}

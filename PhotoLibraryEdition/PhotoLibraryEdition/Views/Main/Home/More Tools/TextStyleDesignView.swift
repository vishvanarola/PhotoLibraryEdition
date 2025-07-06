//
//  TextStyleDesignView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 20/06/25.
//

import SwiftUI

struct TextStyleDesignView: View {
    @State var previewText: String = ""
    @State private var selectedFont: String? = nil
    @State private var showToast = false
    @State private var showNoInternetAlert: Bool = false
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    
    let fontArray = ["Aloevera", "AngelinaPersonal", "BoogieBoysExtrude", "DarlingtonDemo", "Dirtyboy", "EnjelinaDemo", "Inferno", "KingstoneDemoRegular", "KnightWarrior", "MonainnRegular", "MouldyCheeseRegular", "RustyAttackDemo", "Scripto", "SkiwarRegular", "SoulsideBetrayed", "SuperFunky", "SuperRugged", "SuperScribble", "TheHeartOfEverythingDemo", "VeryVeryPunkFont"]
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                previewView
                ScrollView {
                    fontListView
                }
            }
            if showToast {
                VStack {
                    Spacer()
                    Text("Copied")
                        .font(FontConstants.MontserratFonts.medium(size: 17))
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 50)
                }
            }
        }
        .ignoresSafeArea()
        .noInternetAlert(isPresented: $showNoInternetAlert)
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: nil,
            headerTitle: "Text Style",
            leftButtonAction: {
                AdManager.shared.showInterstitialAd()
                isTabBarHidden = false
                navigationPath.removeLast()
            },
            rightButtonAction: nil
        )
    }
    
    var previewView: some View {
        TextField("", text: $previewText, prompt: Text("Preview")
            .font(FontConstants.MontserratFonts.medium(size: 18))
            .foregroundColor(.gray)
        )
        .font(FontConstants.MontserratFonts.semiBold(size: 18))
        .keyboardType(.default)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(redThemeColor, lineWidth: 1)
        )
        .background(pinkThemeColor.opacity(0.05))
        .padding(.horizontal, 20)
        .padding(.top)
    }
    
    var fontListView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(fontArray, id: \.self) { fontName in
                HStack {
                    Text(previewText.isEmpty ? "Sample Text" : previewText)
                        .font(.custom(fontName, size: 24))
                        .foregroundColor(.primary)
                        .padding(.vertical)
                    
                    Spacer()
                    
                    if selectedFont == fontName {
                        Image("ic_copy")
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(redThemeColor, lineWidth: 1)
                )
                .background(pinkThemeColor.opacity(0.05))
                .padding(.horizontal, 20)
                .onTapGesture {
                    if ReachabilityManager.shared.isNetworkAvailable {
                        AdManager.shared.showInterstitialAd()
                        withAnimation {
                            if selectedFont == fontName {
                                selectedFont = nil
                            } else {
                                selectedFont = fontName
                                let textToCopy = previewText.isEmpty ? "Sample Text" : previewText
                                if let uiFont = UIFont(name: fontName, size: 24) {
                                    let attributes: [NSAttributedString.Key: Any] = [
                                        .font: uiFont
                                    ]
                                    let attributedString = NSAttributedString(string: textToCopy, attributes: attributes)
                                    if let rtfData = try? attributedString.data(from: NSRange(location: 0, length: attributedString.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf]) {
                                        UIPasteboard.general.setData(rtfData, forPasteboardType: "public.rtf")
                                    } else {
                                        UIPasteboard.general.string = textToCopy
                                    }
                                } else {
                                    UIPasteboard.general.string = textToCopy
                                }
                                PremiumManager.shared.markUsed()
                                // Show success message
                                showCopiedToast()
                            }
                        }
                    } else {
                        showNoInternetAlert = true

                    }
                }
            }
        }
        .padding(.vertical, 30)
    }
    
    func showCopiedToast() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
        }
    }
}

//
//  PremiumView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 26/06/25.
//

import SwiftUI

struct PlanOption: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let price: String
    let isHighlighted: Bool
}

struct PremiumView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPlanIndex = 2
    @Binding var isTabBarHidden: Bool
    
    let plans: [PlanOption] = [
        PlanOption(title: "₹ 399/ Weekly", subtitle: "₹ 399/week", price: "₹ 399", isHighlighted: false),
        PlanOption(title: "₹ 999/ Monthly", subtitle: "₹ 249/week", price: "₹ 999", isHighlighted: false),
        PlanOption(title: "₹ 5999/ Lifetime", subtitle: "Best valid Plan", price: "₹ 5999", isHighlighted: true)
    ]
    
    var body: some View {
        ZStack {
            backgroundView.ignoresSafeArea()
            VStack(spacing: 0) {
                restoreView
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        headerView
                        featuresView
                        subscriptionPlansView
                        Color.clear
                            .frame(height: 1)
                    }
                    .padding(.top, 10)
                }
                VStack(spacing: 16) {
                    getFullAccessButton
                    footerView
                }
                .padding(.bottom)
            }
            .padding(.horizontal, 20)
        }
    }
    
    var backgroundView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [redThemeColor, pinkGradientColor]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Rectangle()
                .fill(Color.white.opacity(0.9))
        }
    }
    
    var restoreView: some View {
        HStack {
            Button {
                
            } label: {
                Text("Restore")
                    .font(FontConstants.SyneFonts.medium(size: 20))
                    .foregroundStyle(Color.black.opacity(0.5))
            }
            Spacer()
            Button {
                isTabBarHidden = isHideTabBackPremium
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image("ic_close")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 30, height: 30)
        }
        .padding(.top)
    }
    
    var headerView: some View {
        VStack(spacing: 10) {
            Text("Unlock Premium")
                .font(FontConstants.SyneFonts.semiBold(size: 35))
                .overlay(
                    LinearGradient(colors: [redThemeColor, pinkGradientColor],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .mask(Text("Unlock Premium")
                    .font(FontConstants.SyneFonts.semiBold(size: 35)))
            
            Text("access now")
                .font(FontConstants.SyneFonts.semiBold(size: 25))
                .foregroundStyle(.black)
        }
    }
    
    var featuresView: some View {
        VStack(spacing: 16) {
            featureView(text: "HD Quality")
            featureView(text: "Ads Free 100%")
            featureView(text: "Unlimited all Access")
            featureView(text: "High Speed Connectivity")
        }
    }
    
    func featureView(text: String) -> some View {
        HStack {
            Image("ic_check")
            Text(text)
                .font(FontConstants.SyneFonts.medium(size: 17))
            Spacer()
        }
    }
    
    var subscriptionPlansView: some View {
        VStack(spacing: 10) {
            ForEach(Array(plans.enumerated()), id: \.1.id) { index, plan in
                Button(action: {
                    selectedPlanIndex = index
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(plan.title)
                                .font(FontConstants.MontserratFonts.semiBold(size: 18))
                                .foregroundStyle(selectedPlanIndex == index ? .white : .black)
                            Text(plan.subtitle)
                                .font(selectedPlanIndex == index ?
                                      FontConstants.MontserratFonts.semiBold(size: 17) :
                                        FontConstants.MontserratFonts.medium(size: 17))
                                .foregroundStyle(selectedPlanIndex == index ?
                                    .white.opacity(0.7) :
                                                    textGrayColor.opacity(0.7))
                        }
                        Spacer()
                        Image("ic_circle_fill")
                    }
                    .padding()
                    .background(
                        selectedPlanIndex == index ?
                        AnyView(
                            LinearGradient(
                                gradient: Gradient(colors: [redThemeColor, pinkGradientColor]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ) :
                            AnyView(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(textGrayColor.opacity(0.5), lineWidth: 1)
                    )
                    .cornerRadius(15)
                }
            }
        }
    }
    
    var getFullAccessButton: some View {
        Button {
            
        } label: {
            Text("Get Full Access")
                .font(FontConstants.MontserratFonts.bold(size: 17))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [redThemeColor, pinkGradientColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
        }
    }
    
    var footerView: some View {
        HStack(spacing: 0) {
            Button { } label: { Text("▪︎  Privacy & Policy") }
            Spacer()
            Button { } label: { Text("▪︎  Terms & Condition") }
            Spacer()
            Button { } label: { Text("▪︎  EULA") }
        }
        .font(FontConstants.SyneFonts.regular(size: 14))
        .foregroundStyle(.black)
    }
}

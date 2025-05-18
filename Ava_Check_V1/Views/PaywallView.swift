//
//  PaywallView.swift
//  Ava_Check_V1
//
//  Created by William Liu on 2025-05-17.
//

import SwiftUI

class PaywallViewModel:ObservableObject {
    
    enum SubscriptionOption {
        case monthly, yearly
    }
    
    @Published var showTermsAndConditions = false
    @Published var showPrivacyPolicy = false
    @Published private var selectedOption: SubscriptionOption = .monthly
    @Published var selectedProductIndex: Int? = nil
}

struct PaywallView: View {
    @EnvironmentObject
    private var purchaseManager: PurchaseManager
    @EnvironmentObject
    private var coordinator: AppCoordinator
    @StateObject var viewModel: PaywallViewModel = PaywallViewModel()
    
    
    var body: some View {
        VStack {
            
            ZStack {
                Image("Arm")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                    .blur(radius: 2)
                    .opacity(0.6)
                    .clipped()
                    .mask(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .black.opacity(0), location: 0),
                                .init(color: .black, location: 0.1),
                                .init(color: .black, location: 0.9),
                                .init(color: .black.opacity(0), location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                VStack(spacing: 16) {
                    Spacer()
                    
                    Text("Unlock Premium")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Get unlimited access to all features")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    // Feature list
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(icon: "checkmark.circle.fill", text: "Unlimited skin scans")
                        FeatureRow(icon: "checkmark.circle.fill", text: "Advanced skin analysis")
                        FeatureRow(icon: "checkmark.circle.fill", text: "Cancel any time")
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            
            // Subscription options
            VStack(spacing: 16) {
                
                    SubscriptionOptionView(
                        isSelected: viewModel.selectedProductIndex == 0,
                        title: "Yearly Premium",
                        price: purchaseManager.products[0].displayPrice,
                        description: "Save over 50% compared to monthly",
                        isBestValue: true,
                        onTap: { viewModel.selectedProductIndex = 0 }
                    )
                    
                    SubscriptionOptionView(
                        isSelected: viewModel.selectedProductIndex == 1,
                        title: "Monthly Premium",
                        price: purchaseManager.products[1].displayPrice,
                        description: "Billed monthly",
                        onTap: { viewModel.selectedProductIndex = 1 }
                    )
                    
                // Terms and privacy text
                Text("By continuing, you agree to our Terms and Privacy Policy. Subscription automatically renews unless auto-renew is turned off.")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                
                // Subscribe button
                Button {
                    Task {
                        do {
                            if viewModel.selectedProductIndex == 0 {
                                // Purchase first product (monthly)
                                try await purchaseManager.purchase(purchaseManager.products[0])
                                if purchaseManager.hasUnlockedPro == true {
                                    coordinator.navigateTo(.results)
                                }
                                else {
                                    print("You don't have pro, so you cant go to results")
                                }
                            }
                            else if viewModel.selectedProductIndex == 1 {
                                // Purchase second product (yearly)
                                try await purchaseManager.purchase(purchaseManager.products[1])
                                if purchaseManager.hasUnlockedPro == true {
                                    coordinator.navigateTo(.results)
                                }
                                else {
                                    print("You don't have pro, so you cant go to results")
                                }                            }
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    ButtonView(title: "Subscribe Now", image: "lock.open.fill")
                }
                .padding(.bottom, 5)
                
                // Restore purchases button
                HStack {
                    Button {
                        viewModel.showTermsAndConditions = true
                    } label: {
                        Text("Terms and Conditions")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.showPrivacyPolicy = true
                    } label: {
                        Text("Privacy Policy")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
            
            
            .sheet(isPresented: $viewModel.showPrivacyPolicy) {
                PrivacyPolicyView(isPresented: $viewModel.showPrivacyPolicy)
            }
            .sheet(isPresented: $viewModel.showTermsAndConditions) {
                TermsAndConditionsView(isPresented: $viewModel.showTermsAndConditions)
            }
        }
    }
}


    struct FeatureRow: View {
        var icon: String
        var text: String
        
        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                
                Text(text)
                    .foregroundColor(.white)
            }
        }
    }
    // Subscription option view
    struct SubscriptionOptionView: View {
        var isSelected: Bool
        var title: String
        var price: String
        var description: String
        var isBestValue: Bool = false
        var onTap: () -> Void
        
        var body: some View {
            Button(action: onTap) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(title)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            if isBestValue {
                                Text("BEST VALUE")
                                    .font(.system(size: 10, weight: .bold))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.yellow)
                                    .foregroundColor(.black)
                                    .cornerRadius(4)
                            }
                        }
                        
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Text(price)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
                .background(isSelected ? Color.white.opacity(0.3) : Color.white.opacity(0.15))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                )
            }
        }
    }

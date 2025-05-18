//
//  HomeView.swift
//  Ava_Check_V1
//
//  Created by William Liu on 2025-05-17.
//

import SwiftUI

class HomeViewModel: ObservableObject {
}

struct HomeView: View {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @StateObject private var viewModel = HomeViewModel()
    
    @EnvironmentObject private var coordinator: AppCoordinator  // shared coordinator
    
    @EnvironmentObject
    private var purchaseManager: PurchaseManager

    var body: some View {
        VStack{
            Button("Scan") {
                coordinator.navigateTo(.camera)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            Text("Thank you for purchasing pro!")
            Button {
                purchaseManager.resetEntitlementsForTesting()
                hasCompletedOnboarding = false
            } label: {
                Text("Click")
            }
        }
        .onAppear() {
            if hasCompletedOnboarding == false {
                coordinator.navigateTo(.onboarding)
            } 
            
        }
    }
}
#Preview {
    HomeView()
}

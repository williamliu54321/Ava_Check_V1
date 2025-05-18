import SwiftUI
import StoreKit



class AppCoordinator: ObservableObject {
    
    enum AppView {
        case onboarding
        case home
        case camera
        case paywall
        case loading
        case results
    }
    
    @Published var currentView: AppView = .home

    
    func navigateTo(_ view: AppView) {
        currentView = view
    }
    
    func continueToResults() {
        currentView = .results
    }

}
import SwiftUI

struct RootView: View {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @StateObject private var coordinator = AppCoordinator()
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    var body: some View {
        Group {
            switch coordinator.currentView {
            case .home:
                HomeView()
            case .camera:
                CameraView()
            case .paywall:
                PaywallView()
            case .onboarding:
                OnboardingView()
            case .loading:
                LoadingView()
            case .results:
                ResultsView()
            }
        }
        .onAppear(){
            purchaseManager.resetEntitlementsForTesting()
            print("On APpear entitlements reset")
            hasCompletedOnboarding = false
        }
        .environmentObject(coordinator) // ✅ Injected here
    }
}

struct ResultsView: View {
    var body: some View {
        Text("Yay it works")
    }
}


//struct RootView: View {
//    
////    @EnvironmentObject
////    private var entitlementManager: EntitlementManager
//    
//    @EnvironmentObject
//    private var purchaseManager: PurchaseManager
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            if purchaseManager.isLoadingPro || purchaseManager.products.isEmpty {
//                LoadingView()
//            } else if purchaseManager.hasUnlockedPro {
//                HomeView()
//            } else{
//                OnboardingView()
//            }
//            
//            if viewModel.isShowingCamera {
//                CameraView(viewModel: viewModel)
//                    .transition(.move(edge: .bottom))
//                    .zIndex(1)
//            }
//            
//            if viewModel.isShowingPaywall {
//                PaywallView(viewModel: viewModel)
//                    .transition(.opacity)
//                    .zIndex(2)
//            }
//
//        }
//        .task {
//                    do {
//                        try await purchaseManager.loadProducts()
//                    } catch {
//                        print(error)
//                    }
//                }
//        }
//
//    }


struct LoadingView: View {
    var body: some View {
        ProgressView("Checking your purchase...")
    }
}




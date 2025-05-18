import SwiftUI

// MARK: - Onboarding ViewModel
final class OnboardingViewModel: ObservableObject {
    let totalSteps: Int
    
    @Published var currentStep = 0
    
    init(totalSteps: Int = 5) {
        self.totalSteps = totalSteps
    }
    
    // Navigation methods
    func moveToNextStep() {
        if currentStep < totalSteps - 1 {
            currentStep += 1
        }
    }
    
    func moveToPreviousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
    // Computed properties for convenience
    var isFirstStep: Bool {
        currentStep == 0
    }
    
    var isLastStep: Bool {
        currentStep == totalSteps - 1
    }
    
    // Progress as a percentage (0.0 to 1.0)
   
    // Complete onboarding
    func completeOnboarding() {
        // Save that onboarding is complete
        print("Onboarding Completed")
    }
}

// MARK: - Main Onboarding Container
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel(totalSteps: 2)
        
    var body: some View {
        ZStack {
            // Background color
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
            
            VStack {
                
                // Content pages
                TabView(selection: $viewModel.currentStep) {
                    // Add your onboarding pages here
                    WelcomeView(viewModel: viewModel).tag(0)
                    OnboardingCameraView(viewModel: viewModel).tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentStep)
            }
        }
        .appBackground()
    }
}

// MARK: - Onboarding Pages
struct WelcomeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "faceid")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(.white)
                .padding(.bottom, 40)
            
            VStack(spacing: 8) {
                Text("Welcome to")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Ava Check")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding()
            
            Text("Advanced AI analysis of your skin condition")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()

            Button(action: {
                viewModel.moveToNextStep()
            }) {
                ButtonView(title: "Get Started", image: "arrow.right.circle")
            }
            .padding(.bottom, 50)
        }
    }
}

struct OnboardingCameraView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "camera.viewfinder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(.white)
                .padding(.bottom, 40)
            
            VStack(spacing: 8) {
                Text("Start Scanning")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your Skin")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding()
            
            Spacer()
            
            Text("Ava Check may contain errors or inaccuracies. It is not a substitute for professional medical advice. Please consult a healthcare provider for any health concerns")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .padding(.bottom, 40)
                .padding(.horizontal, 40)
            
            Button {
                coordinator.navigateTo(.camera)
            } label: {
                ButtonView(title: "Scan", image: "arrow.right.circle.fill")
            }
            .padding(.bottom, 50)
        }
    }
}



#Preview {
    OnboardingView()
        .environmentObject(PurchaseManager(entitlementManager: EntitlementManager()))
}


//struct PaywallView: View {
//    
//    @EnvironmentObject
//    private var purchaseManager: PurchaseManager
//    
//    @State private var selectedOption: SubscriptionOption = .monthly
//    
//    enum SubscriptionOption {
//        case monthly, yearly
//    }
//    
//    var body: some View {
//        VStack{
//            Text("Products")
//                .font(.title2)
//            
//            ForEach(purchaseManager.products) { product in
//                SubscriptionOptionView(
//                    isSelected: selectedOption == .yearly,
//                    title: "Yearly",
//                    price: "$39.99",
//                    description: "Save 52% compared to monthly",
//                    isBestValue: true,
//                    onTap: { selectedOption = .yearly }
//                )
//                Button {
//                    Task {
//                        do {
//                            try await purchaseManager.purchase(product)
//                        } catch {
//                            print(error)
//                        }
//                    }
//                } label: {
//                    Text("\(product.displayPrice) - \(product.displayName)")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .clipShape(Capsule())
//                }
//            }
//            Button {
//                Task {
//                    if !purchaseManager.hasUnlockedPro {
//                        do {
//                            try await purchaseManager.loadProducts()
//                        } catch {
//                            print(error)
//                        }
//                    }
//                }
//            } label: {
//                Text("Restore Purchases")
//            }
//        
//        }
//    }
//}

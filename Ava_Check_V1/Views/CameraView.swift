//
//  CameraView.swift
//  Ava_Check_V1
//
//  Created by William Liu on 2025-05-17.
//

import SwiftUI
import AVFoundation

class CameraViewModel: ObservableObject {
    
    enum CameraViewPage {
        case requestingPermission  // Asking for camera access
        case takingPhoto           // Ready to take a photo
        case analyzing             // Processing the photo
        case showingResults        // Displaying diagnosis
        case error(String)         // Showing error message
    }
    
    
    @Published var isCameraActive = false
    @Published private var cameraViewPage: CameraViewPage = .requestingPermission
    
    
    func activateCamera() {
        isCameraActive = true
    }
    
    func capturePhoto() {
        // Camera logic here
    }

}

import SwiftUI

// MARK: - Main App Flow View
/// Manages the entire camera flow and state transitions
struct CameraView: View {
    // View model to manage the application state and logic
    @StateObject private var viewModel = CameraViewModel()
    
    @EnvironmentObject
    private var purchaseManager: PurchaseManager
    
    @EnvironmentObject
    private var coordinator: AppCoordinator
    
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    
    var body: some View {
        VStack {
            Text("Camera")
            Button("GO to home") {
                hasCompletedOnboarding = true
                coordinator.navigateTo(.home)
            }
        }
        .onAppear {
            // Put your navigation logic here instead of in the body
            if !purchaseManager.hasUnlockedPro {
                print("we don't have pro")
                coordinator.navigateTo(.paywall)
            }
            else {
                print("we have pro")
            }
            
            
            //        .onAppear {
            //            // Request camera permission if needed when view appears
            //            if viewModel.Camera == .requestingPermission {
            //                viewModel.requestCameraPermission()
            //            }
            //        }
        }
    }
}
    
    /// Renders different views based on the current application state
//    @ViewBuilder
//    private var contentBasedOnState: some View {
//        switch viewModel.flowState {
//        case .requestingPermission:
//            PermissionRequestView(viewModel: viewModel)
//        case .takingPhoto:
//            CameraPreviewView(viewModel: viewModel)
//        case .analyzing:
//            AnalyzingView(image: viewModel.capturedImage)
//        case .showingResults:
//            ResultsView(viewModel: viewModel)
//        case .error(let message):
//            ErrorView(message: message, viewModel: viewModel)
//        }
//    }


//
//  Extensions.swift
//  Ava_Check_V1
//
//  Created by William Liu on 2025-05-16.
//

import SwiftUI
/// Background color extension with gradient
extension View {
    func appBackground() -> some View {
        ZStack {
            // Use a linear gradient that fills the entire screen
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.18, green: 0.8, blue: 0.8),
                    Color(red: 0.4, green: 0.65, blue: 0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea() // First Layer - Gradient background
            
            self // Second Layer - Content
        }
    }
}

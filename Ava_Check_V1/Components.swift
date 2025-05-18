//
//  ButtonView.swift
//  IOS_Onboarding_Template
//
//  Created by William Liu on 2025-04-15.
//

import SwiftUI

struct ButtonView: View {
    var title: String
    var image: String

    var body: some View {
        HStack {
            Image(systemName: image)
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .default))
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.25))
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
        )
        .foregroundColor(.white)
        .clipShape(Capsule())
        .padding(.horizontal, 40)
    }
}

// Extension for preview (you can remove this part when using in your app)
struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Background gradient for preview
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.18, green: 0.8, blue: 0.8),
                    Color(red: 0.4, green: 0.65, blue: 0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ButtonView(title: "Get Started", image: "arrow.right.circle")
        }
    }
}

struct CheckBoxView: View {
    @State private var ticked: Bool = false
    var text: String

    var body: some View {
        Button(action: {
            ticked.toggle()
        }) {
            HStack {
                Text(text)
                    .font(.system(size: 18, weight: .medium))

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 26, height: 26)

                    if ticked {
                        ZStack {
                            // Gradient background
                            RoundedRectangle(cornerRadius: 5)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.18, green: 0.8, blue: 0.8),
                                            Color(red: 0.4, green: 0.65, blue: 0.9)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )

                            // Checkmark icon
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                        }
                        .frame(width: 26, height: 26)
                    }

                }
            }
            .padding(.horizontal)
            .frame(width: 375, height: 46)
            .background(
                RoundedRectangle(cornerRadius: 15)
            )
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button look
    }
}



#Preview {
    ButtonView(title: "Get Started", image: "play.fill")
}

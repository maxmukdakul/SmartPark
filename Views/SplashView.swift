//
//  SplashView.swift
//  SmartPark
//

import SwiftUI

struct SplashView: View {
    @State private var iconScale: CGFloat = 0.3
    @State private var iconOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var glowRadius: CGFloat = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(.yellow.opacity(0.15))
                        .frame(width: 180, height: 180)
                        .blur(radius: glowRadius)

                    Image(systemName: "car.top.radiowaves.rear.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.yellow)
                }
                .scaleEffect(iconScale)
                .opacity(iconOpacity)

                VStack(spacing: 8) {
                    Text("SmartPark")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Find. Reserve. Park.")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.yellow.opacity(0.8))
                        .tracking(3)
                }
                .opacity(textOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.6)) {
                iconScale = 1.0
                iconOpacity = 1.0
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowRadius = 30
            }
            withAnimation(.easeIn(duration: 0.6).delay(0.4)) {
                textOpacity = 1.0
            }
        }
    }
}

//
//  LoginView.swift
//  SmartPark
//
//  Created by Max on 9/5/2569 BE.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var logoScale: CGFloat = 0.8
    @State private var contentOpacity: Double = 0
    @State private var showGoogleSheet = false

    private let features = [
        ("map.fill", "Live Map", "See available parking spots in real-time"),
        ("clock.badge.checkmark.fill", "Quick Reserve", "Book your spot before you arrive"),
        ("bell.badge.fill", "Smart Alerts", "Get notified before your time expires"),
        ("chart.bar.fill", "History", "Track all your parking activity")
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(.yellow.opacity(0.1))
                            .frame(width: 140, height: 140)

                        Image(systemName: "car.top.radiowaves.rear.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.yellow)
                    }
                    .scaleEffect(logoScale)

                    Text("SmartPark")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Find and reserve parking in real-time")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .opacity(contentOpacity)

                Spacer().frame(height: 40)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(features, id: \.1) { icon, title, subtitle in
                            VStack(spacing: 10) {
                                Image(systemName: icon)
                                    .font(.title2)
                                    .foregroundStyle(.yellow)

                                Text(title)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)

                                Text(subtitle)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            .frame(width: 120, height: 110)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(14)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .opacity(contentOpacity)

                Spacer()

                VStack(spacing: 14) {
                    Button(action: {
                        showGoogleSheet = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "g.circle.fill")
                                .font(.title2)
                            Text("Continue with Google")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.white)
                        .foregroundStyle(.black)
                        .cornerRadius(14)
                    }

                    Button(action: {
                        showGoogleSheet = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "apple.logo")
                                .font(.title2)
                            Text("Continue with Apple")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.yellow)
                        .foregroundStyle(.black)
                        .cornerRadius(14)
                    }

                    Text("By continuing, you agree to our Terms of Service")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                        .padding(.top, 4)
                }
                .opacity(contentOpacity)
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }

            if authManager.isLoading {
                ZStack {
                    Color.black.opacity(0.6).ignoresSafeArea()

                    VStack(spacing: 16) {
                        ProgressView()
                            .controlSize(.large)
                            .tint(.yellow)

                        Text("Signing in...")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                logoScale = 1.0
            }
            withAnimation(.easeIn(duration: 0.6).delay(0.2)) {
                contentOpacity = 1.0
            }
        }
        .sheet(isPresented: $showGoogleSheet) {
            GoogleAccountPicker()
        }
    }
}

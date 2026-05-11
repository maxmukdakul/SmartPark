//
//  SmartParkApp.swift
//  SmartPark
//
//  Created by Max on 9/5/2569 BE.
//

import SwiftUI

@main
struct SmartParkApp: App {
    @State private var authManager = AuthManager()
    @State private var parkingManager = ParkingManager()
    @State private var showSplash = true
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ZStack {
                if authManager.isAuthenticated {
                    MainTabView()
                        .environment(authManager)
                        .environment(parkingManager)
                        .transition(.opacity.combined(with: .scale(scale: 0.98)))
                } else {
                    LoginView()
                        .environment(authManager)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: authManager.isAuthenticated)
            .overlay {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    parkingManager.expireOldReservations()
                }
            }
            .onChange(of: authManager.isAuthenticated) { _, isAuth in
                if isAuth, let email = authManager.currentUser?.email {
                    parkingManager.loadData(for: email)
                }
            }
        }
    }
}

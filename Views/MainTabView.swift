//
//  MainTabView.swift
//  SmartPark
//

import SwiftUI

struct MainTabView: View {
    @Environment(ParkingManager.self) private var parkingManager

    var body: some View {
        TabView {
            ParkingMapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }

            HistoryLogView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
                .badge(parkingManager.activeReservations.count)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tint(.yellow)
    }
}

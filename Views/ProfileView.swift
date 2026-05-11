//
//  ProfileView.swift
//  SmartPark
//
//  Created by Max on 9/5/2569 BE.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(ParkingManager.self) private var parkingManager
    @State private var showLogoutAlert = false

    private var totalSpent: Double {
        parkingManager.reservations.reduce(0) { $0 + $1.totalCost }
    }

    var body: some View {
        @Bindable var manager = parkingManager
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 72, height: 72)

                            Text(authManager.currentUser?.initial ?? "U")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }

                        VStack(spacing: 4) {
                            Text(authManager.currentUser?.name ?? "SmartPark User")
                                .font(.title3)
                                .fontWeight(.bold)

                            Text(authManager.currentUser?.email ?? "user@gmail.com")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(20)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        StatCard(icon: "car.fill", value: "\(parkingManager.reservations.count)", label: "Bookings", color: .yellow)
                        StatCard(icon: "clock.fill", value: "\(parkingManager.activeReservations.count)", label: "Active", color: .blue)
                        StatCard(icon: "star.fill", value: "\(parkingManager.favoriteSpaces.count)", label: "Favorites", color: .orange)
                        StatCard(icon: "banknote", value: "\(String(format: "%.0f", totalSpent))", label: "THB Spent", color: .green)
                    }

                    VStack(spacing: 0) {
                        SectionHeader(title: "Settings")

                        Toggle(isOn: $manager.notificationsEnabled) {
                            SettingsRow(icon: "bell.fill", title: "Push Notifications", color: .orange)
                        }
                        .tint(.yellow)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .background(Color.white)
                    .cornerRadius(16)

                    VStack(spacing: 0) {
                        SectionHeader(title: "About")

                        VStack(spacing: 0) {
                            HStack {
                                SettingsRow(icon: "info.circle.fill", title: "Version", color: .gray)
                                Spacer()
                                Text("1.0.0")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)

                            Divider().padding(.leading, 52)

                            HStack {
                                SettingsRow(icon: "person.2.fill", title: "Developers", color: .purple)
                                Spacer()
                                Text("Chanotai & Thanutham")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)

                            Divider().padding(.leading, 52)

                            HStack {
                                SettingsRow(icon: "graduationcap.fill", title: "University", color: .green)
                                Spacer()
                                Text("Kasetsart University")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(16)

                    Button(role: .destructive) {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(14)
                    }

                    Color.clear.frame(height: 10)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .background(Color(white: 0.95))
            .navigationTitle("Profile")
            .alert("Sign Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    if let email = authManager.currentUser?.email {
                        parkingManager.saveData(for: email)
                    }
                    withAnimation {
                        authManager.signOut()
                    }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

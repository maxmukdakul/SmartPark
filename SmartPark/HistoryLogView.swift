//
//  HistoryLogView.swift
//  SmartPark
//
//  Created by Max on 9/5/2569 BE.
//

import SwiftUI

struct HistoryLogView: View {
    @Environment(ParkingManager.self) private var parkingManager
    @State private var selectedFilter: HistoryFilter = .all
    @State private var cancelTargetID: UUID?
    @State private var showCancelAlert = false

    enum HistoryFilter: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case completed = "Completed"
        case cancelled = "Cancelled"
    }

    var filteredReservations: [Reservation] {
        switch selectedFilter {
        case .all: return parkingManager.reservations
        case .active: return parkingManager.reservations.filter { $0.status == .active }
        case .completed: return parkingManager.reservations.filter { $0.status == .completed }
        case .cancelled: return parkingManager.reservations.filter { $0.status == .cancelled }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(HistoryFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 10)

                if filteredReservations.isEmpty {
                    ContentUnavailableView(
                        "No Reservations",
                        systemImage: "car.side",
                        description: Text("Your parking history will appear here once you make a booking.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredReservations) { reservation in
                                ReservationCard(reservation: reservation) {
                                    cancelTargetID = reservation.id
                                    showCancelAlert = true
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 20)
                    }
                }
            }
            .background(Color(white: 0.95))
            .navigationTitle("Parking History")
            .alert("Cancel Booking", isPresented: $showCancelAlert) {
                Button("Keep Booking", role: .cancel) { }
                Button("Cancel Booking", role: .destructive) {
                    if let id = cancelTargetID {
                        withAnimation {
                            parkingManager.cancelReservation(id: id)
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to cancel this booking? This cannot be undone.")
            }
        }
    }
}

// MARK: - Reservation Card

struct ReservationCard: View {
    let reservation: Reservation
    var onCancel: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            if reservation.status == .active {
                HStack(spacing: 6) {
                    Circle()
                        .fill(.blue)
                        .frame(width: 6, height: 6)
                    Text("ACTIVE NOW")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .tracking(0.5)
                }
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(.blue.opacity(0.08))
            }

            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(reservation.status.color.opacity(0.12))
                            .frame(width: 42, height: 42)

                        Image(systemName: reservation.status.icon)
                            .font(.system(size: 18))
                            .foregroundStyle(reservation.status.color)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(reservation.parkingName)
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text(reservation.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 3) {
                        Text("\(String(format: "%.0f", reservation.totalCost)) THB")
                            .font(.subheadline)
                            .fontWeight(.bold)

                        Text(reservation.formattedTimeRange)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 16) {
                    Label("\(reservation.durationHours)h", systemImage: "clock")
                    Label(reservation.formattedStartTime, systemImage: "calendar.badge.clock")
                    Spacer()

                    if reservation.status == .active, let onCancel {
                        Button("Cancel", role: .destructive, action: onCancel)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(.red.opacity(0.1))
                            .cornerRadius(6)
                    } else {
                        StatusBadge(title: reservation.status.rawValue, color: reservation.status.color)
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

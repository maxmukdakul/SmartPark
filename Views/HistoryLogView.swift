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

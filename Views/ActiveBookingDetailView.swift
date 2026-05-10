//
//  ActiveBookingDetailView.swift
//  SmartPark
//

import SwiftUI

struct ActiveBookingDetailView: View {
    let space: ParkingSpace
    let reservation: Reservation
    @Environment(ParkingManager.self) private var parkingManager
    @Environment(\.dismiss) private var dismiss
    @State private var showCancelAlert = false
    @State private var showCannotCancelAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.blue.opacity(0.12))
                                    .frame(width: 56, height: 56)

                                Image(systemName: space.type.icon)
                                    .font(.system(size: 24))
                                    .foregroundStyle(.blue)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(space.name)
                                    .font(.headline)

                                HStack(spacing: 4) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.caption2)
                                    Text(space.address)
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }

                            Spacer()

                            StatusBadge(title: "Booked", color: .blue)
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)

                        VStack(spacing: 14) {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 8, height: 8)
                                Text("YOUR ACTIVE BOOKING")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .tracking(0.5)
                            }
                            .foregroundStyle(.blue)

                            VStack(spacing: 12) {
                                InfoRow(icon: "calendar", label: reservation.startTime.formatted(.dateTime.day().month(.wide).year()))
                                InfoRow(icon: "clock.fill", label: reservation.formattedTimeRange + "  (\(reservation.durationHours)h)")
                                InfoRow(icon: "banknote", label: "\(String(format: "%.0f", reservation.totalCost)) THB")
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)

                        Button {
                            parkingManager.openDirections(to: space)
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                    .font(.subheadline)
                                Text("Get Directions")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(14)
                            .background(Color.blue.opacity(0.1))
                            .foregroundStyle(.blue)
                            .cornerRadius(12)
                        }

                        if reservation.canCancel {
                            VStack(spacing: 6) {
                                Button(role: .destructive) {
                                    showCancelAlert = true
                                } label: {
                                    Text("Cancel Booking")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(.red.opacity(0.1))
                                        .foregroundStyle(.red)
                                        .cornerRadius(14)
                                }

                                Text("Cancel before \(reservation.cancelDeadline)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        } else {
                            HStack(spacing: 6) {
                                Image(systemName: "lock.fill")
                                    .font(.caption2)
                                Text("Cancellation closed — less than 1 hour before start time")
                                    .font(.caption)
                            }
                            .foregroundStyle(.secondary)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color(white: 0.93))
                            .cornerRadius(10)
                        }
                    }
                    .padding(20)
                }
                .background(Color(white: 0.95))
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .alert("Cancel Booking", isPresented: $showCancelAlert) {
            Button("Keep Booking", role: .cancel) { }
            Button("Cancel Booking", role: .destructive) {
                withAnimation {
                    parkingManager.cancelReservation(id: reservation.id)
                }
                dismiss()
            }
        } message: {
            Text("Cancel your booking at \(reservation.parkingName)?")
        }
    }
}

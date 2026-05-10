//
//  ActiveBookingBanner.swift
//  SmartPark
//

import SwiftUI

struct ActiveBookingBanner: View {
    let reservation: Reservation
    var onLocate: (() -> Void)?
    @Environment(ParkingManager.self) private var parkingManager
    @State private var showCancelAlert = false
    @State private var showCannotCancelAlert = false

    var body: some View {
        HStack(spacing: 14) {
            Button {
                onLocate?()
            } label: {
                ZStack {
                    Circle()
                        .fill(.blue.opacity(0.15))
                        .frame(width: 42, height: 42)

                    Image(systemName: "car.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.blue)
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("ACTIVE BOOKING")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(.blue)
                    .tracking(0.5)

                Text(reservation.parkingName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }

            Spacer()

            Button {
                if reservation.canCancel {
                    showCancelAlert = true
                } else {
                    showCannotCancelAlert = true
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .trailing, spacing: 2) {
                Text(reservation.startTime, format: .dateTime.day().month(.abbreviated))
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                Text(reservation.formattedTimeRange)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(8)
        }
        .padding(14)
        .background(.ultraThickMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 10, y: 5)
        .padding(.horizontal)
        .alert("Cancel Booking", isPresented: $showCancelAlert) {
            Button("Keep Booking", role: .cancel) { }
            Button("Cancel Booking", role: .destructive) {
                withAnimation {
                    parkingManager.cancelReservation(id: reservation.id)
                }
            }
        } message: {
            Text("Cancel your booking at \(reservation.parkingName)?")
        }
        .alert("Cannot Cancel", isPresented: $showCannotCancelAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Cancellation is not allowed within 1 hour of your booking start time (\(reservation.formattedStartTime)). The cancel deadline was \(reservation.cancelDeadline).")
        }
    }
}

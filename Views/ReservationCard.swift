//
//  ReservationCard.swift
//  SmartPark
//

import SwiftUI

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

                    if reservation.status == .active {
                        if reservation.canCancel, let onCancel {
                            Button("Cancel", role: .destructive, action: onCancel)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 5)
                                .background(.red.opacity(0.1))
                                .cornerRadius(6)
                        } else {
                            Text("Can't cancel")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color(white: 0.93))
                                .cornerRadius(6)
                        }
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

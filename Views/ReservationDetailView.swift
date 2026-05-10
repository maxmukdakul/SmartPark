//
//  ReservationDetailView.swift
//  SmartPark
//

import SwiftUI

struct ReservationDetailView: View {
    let space: ParkingSpace
    @Environment(ParkingManager.self) private var parkingManager
    @Environment(\.dismiss) private var dismiss
    @State private var duration = 1
    @State private var startTime = Date()
    @State private var bookingState: BookingState = .details

    enum BookingState {
        case details
        case success
    }

    private var formattedTimeRange: String {
        let end = startTime.addingTimeInterval(Double(duration) * 3600)
        let df = DateFormatter()
        df.dateFormat = "d MMM yyyy, HH:mm"
        let tf = DateFormatter()
        tf.dateFormat = "HH:mm"
        return "\(df.string(from: startTime)) - \(tf.string(from: end))"
    }

    private var totalCost: Double {
        space.pricePerHour * Double(duration)
    }

    var body: some View {
        NavigationStack {
            Group {
                if bookingState == .success {
                    successView
                } else {
                    detailsView
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                if bookingState == .details {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            parkingManager.toggleFavorite(space)
                        } label: {
                            Image(systemName: parkingManager.isFavorite(space) ? "star.fill" : "star")
                                .foregroundStyle(.yellow)
                        }
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private var detailsView: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.yellow.opacity(0.12))
                            .frame(width: 56, height: 56)

                        Image(systemName: space.type.icon)
                            .font(.system(size: 24))
                            .foregroundStyle(.yellow)
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

                    StatusBadge(
                        title: space.isAvailable ? "Open" : "Full",
                        color: space.isAvailable ? .green : .red
                    )
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

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Capacity")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(space.availableSpots) of \(space.totalSpots) available")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.gray.opacity(0.15))
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: space.occupancyRate > 0.8 ? [.orange, .red] : [.green, .mint],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * space.occupancyRate)
                        }
                    }
                    .frame(height: 10)

                    HStack(spacing: 16) {
                        Label("\(Int(space.occupancyRate * 100))% occupied", systemImage: "car.2.fill")
                        Spacer()
                        Label("\(Int(space.pricePerHour))฿/hr", systemImage: "banknote")
                            .foregroundStyle(.yellow)
                            .fontWeight(.semibold)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(16)

                if space.isAvailable && parkingManager.isOnCooldown {
                    VStack(spacing: 14) {
                        Image(systemName: "clock.badge.exclamationmark")
                            .font(.system(size: 44))
                            .foregroundStyle(.orange)
                        Text("Booking Cooldown")
                            .font(.headline)
                        Text("You recently cancelled a booking. Please wait \(parkingManager.cooldownRemainingMinutes) minute\(parkingManager.cooldownRemainingMinutes == 1 ? "" : "s") before making a new reservation.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .cornerRadius(16)
                } else if space.isAvailable {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Reservation")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        DatePicker("Date", selection: $startTime, in: Date()..., displayedComponents: .date)
                        DatePicker("Time", selection: $startTime, displayedComponents: .hourAndMinute)
                        Stepper("Duration: \(duration) hr\(duration > 1 ? "s" : "")", value: $duration, in: 1...12)

                        Divider()

                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Schedule")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(formattedTimeRange)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("Total")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("\(String(format: "%.0f", totalCost)) THB")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)

                    Button(action: {
                        parkingManager.bookSpace(space, duration: duration, startTime: startTime)
                        withAnimation(.spring(response: 0.5)) {
                            bookingState = .success
                        }
                    }) {
                        Text("Confirm Booking")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.yellow)
                            .foregroundStyle(.black)
                            .cornerRadius(14)
                    }
                } else {
                    VStack(spacing: 14) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.orange)
                        Text("Parking lot is full")
                            .font(.headline)
                        Text("Try another location or check back later.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color.white)
                    .cornerRadius(16)

                    Button(action: { dismiss() }) {
                        Text("Find Other Parking")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.yellow)
                            .foregroundStyle(.black)
                            .cornerRadius(14)
                    }
                }
            }
            .padding(20)
        }
        .background(Color(white: 0.95))
    }

    private var successView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(.green.opacity(0.12))
                        .frame(width: 120, height: 120)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.green)
                        .symbolEffect(.bounce, value: bookingState)
                }

                Text("Booking Confirmed!")
                    .font(.title2)
                    .fontWeight(.bold)

                VStack(spacing: 12) {
                    InfoRow(icon: "building.2.fill", label: space.name)
                    InfoRow(icon: "clock.fill", label: formattedTimeRange + "  (\(duration)h)")
                    InfoRow(icon: "banknote", label: "\(String(format: "%.0f", totalCost)) THB")
                    InfoRow(icon: "xmark.circle", label: "Cancel before \(cancelDeadlineText)")
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(14)

                HStack(spacing: 6) {
                    Image(systemName: "bell.fill")
                        .font(.caption2)
                    Text("You'll be notified 15 min before expiry")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)

            Spacer()

            VStack(spacing: 10) {
                Button {
                    parkingManager.openDirections(to: space)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                        Text("Get Directions")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(14)
                }

                Button(action: { dismiss() }) {
                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.yellow)
                        .foregroundStyle(.black)
                        .cornerRadius(14)
                }
            }
            .padding(20)
        }
        .background(Color(white: 0.95))
    }

    private var cancelDeadlineText: String {
        let deadline = startTime.addingTimeInterval(-3600)
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy, HH:mm"
        return f.string(from: deadline)
    }
}

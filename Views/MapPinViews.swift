//
//  MapPinViews.swift
//  SmartPark
//

import SwiftUI
import MapKit

// MARK: - Booked Pin (pulsing blue)

struct BookedPinView: View {
    let space: ParkingSpace
    let action: () -> Void
    @State private var pulse = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                ZStack {
                    Circle()
                        .fill(.blue.opacity(0.2))
                        .frame(width: 56, height: 56)
                        .scaleEffect(pulse ? 1.3 : 1.0)
                        .opacity(pulse ? 0 : 0.6)

                    Circle()
                        .fill(.blue)
                        .frame(width: 44, height: 44)
                        .shadow(color: .blue.opacity(0.5), radius: 8, y: 3)

                    Image(systemName: "car.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                }

                Text("YOUR BOOKING")
                    .font(.system(size: 8, weight: .bold, design: .rounded))
                    .tracking(0.5)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(4)
                    .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                pulse = true
            }
        }
    }
}

// MARK: - Parking Pin

struct ParkingPinView: View {
    let space: ParkingSpace
    let isFavorite: Bool
    let action: () -> Void
    @State private var appear = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                ZStack {
                    Circle()
                        .fill(space.isAvailable ? .green : .red.opacity(0.85))
                        .frame(width: 40, height: 40)
                        .shadow(color: (space.isAvailable ? Color.green : Color.red).opacity(0.4), radius: 6, y: 3)

                    Image(systemName: space.isAvailable ? space.type.icon : "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)

                    if isFavorite {
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(.yellow)
                            .offset(x: 14, y: -14)
                    }
                }

                Text("\(Int(space.pricePerHour))฿")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.white)
                    .cornerRadius(4)
                    .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
            }
            .scaleEffect(appear ? 1.0 : 0.5)
            .opacity(appear ? 1.0 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(Double.random(in: 0...0.3))) {
                appear = true
            }
        }
    }
}

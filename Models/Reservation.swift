//
//  Reservation.swift
//  SmartPark
//

import Foundation
import SwiftUI

enum ReservationStatus: String {
    case active = "Active"
    case completed = "Completed"
    case cancelled = "Cancelled"

    var color: Color {
        switch self {
        case .active: return .blue
        case .completed: return .green
        case .cancelled: return .red
        }
    }

    var icon: String {
        switch self {
        case .active: return "clock.fill"
        case .completed: return "checkmark.circle.fill"
        case .cancelled: return "xmark.circle.fill"
        }
    }
}

struct Reservation: Identifiable {
    let id = UUID()
    let parkingName: String
    let date: Date
    let startTime: Date
    let durationHours: Int
    let totalCost: Double
    var status: ReservationStatus

    var endTime: Date {
        startTime.addingTimeInterval(Double(durationHours) * 3600)
    }

    var canCancel: Bool {
        guard status == .active else { return false }
        return Date() < startTime.addingTimeInterval(-3600)
    }

    var cancelDeadline: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy, HH:mm"
        let deadline = startTime.addingTimeInterval(-3600)
        return formatter.string(from: deadline)
    }

    var formattedTimeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }

    var formattedStartTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: startTime)
    }
}

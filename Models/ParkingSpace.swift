//
//  ParkingSpace.swift
//  SmartPark
//

import Foundation
import MapKit

struct ParkingSpace: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    var isAvailable: Bool
    let totalSpots: Int
    let availableSpots: Int
    let pricePerHour: Double
    let type: ParkingType

    var occupancyRate: Double {
        guard totalSpots > 0 else { return 1.0 }
        return Double(totalSpots - availableSpots) / Double(totalSpots)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ParkingSpace, rhs: ParkingSpace) -> Bool {
        lhs.id == rhs.id
    }
}

enum ParkingType: String, CaseIterable, Hashable {
    case mall = "Mall"
    case office = "Office"
    case hospital = "Hospital"
    case university = "University"
    case transit = "Transit"
    case outdoor = "Outdoor"

    var icon: String {
        switch self {
        case .mall: return "building.2.fill"
        case .office: return "building.fill"
        case .hospital: return "cross.circle.fill"
        case .university: return "graduationcap.fill"
        case .transit: return "tram.fill"
        case .outdoor: return "car.fill"
        }
    }
}

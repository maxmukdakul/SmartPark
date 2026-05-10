//
//  MockData.swift
//  SmartPark
//

import Foundation
import MapKit

class MockData {
    static let sampleParkingSpaces = [
        ParkingSpace(name: "CentralWorld Parking", address: "999/9 Rama I Rd, Pathum Wan", coordinate: CLLocationCoordinate2D(latitude: 13.7466, longitude: 100.5392), isAvailable: true, totalSpots: 150, availableSpots: 12, pricePerHour: 40.0, type: .mall),
        ParkingSpace(name: "Siam Paragon Parking", address: "991 Rama I Rd, Pathum Wan", coordinate: CLLocationCoordinate2D(latitude: 13.7461, longitude: 100.5349), isAvailable: true, totalSpots: 100, availableSpots: 3, pricePerHour: 60.0, type: .mall),
        ParkingSpace(name: "ICON SIAM Parking", address: "299 Charoen Nakhon Rd, Khlong San", coordinate: CLLocationCoordinate2D(latitude: 13.7265, longitude: 100.5100), isAvailable: true, totalSpots: 250, availableSpots: 78, pricePerHour: 50.0, type: .mall),
        ParkingSpace(name: "Terminal 21 Asok", address: "88 Sukhumvit Rd Soi 19, Watthana", coordinate: CLLocationCoordinate2D(latitude: 13.7376, longitude: 100.5602), isAvailable: true, totalSpots: 120, availableSpots: 22, pricePerHour: 45.0, type: .mall),
        ParkingSpace(name: "MBK Center Parking", address: "444 Phaya Thai Rd, Wang Mai", coordinate: CLLocationCoordinate2D(latitude: 13.7441, longitude: 100.5300), isAvailable: false, totalSpots: 90, availableSpots: 0, pricePerHour: 35.0, type: .mall),
        ParkingSpace(name: "EmQuartier Parking", address: "693 Sukhumvit Rd, Khlong Tan Nuea", coordinate: CLLocationCoordinate2D(latitude: 13.7310, longitude: 100.5695), isAvailable: true, totalSpots: 180, availableSpots: 41, pricePerHour: 55.0, type: .mall),
        ParkingSpace(name: "Silom Office Tower", address: "456 Silom Rd, Bang Rak", coordinate: CLLocationCoordinate2D(latitude: 13.7262, longitude: 100.5234), isAvailable: false, totalSpots: 80, availableSpots: 0, pricePerHour: 50.0, type: .office),
        ParkingSpace(name: "Sathorn Square Tower", address: "98 Sathorn Rd, Silom", coordinate: CLLocationCoordinate2D(latitude: 13.7215, longitude: 100.5275), isAvailable: true, totalSpots: 110, availableSpots: 8, pricePerHour: 60.0, type: .office),
        ParkingSpace(name: "Ramathibodi Hospital", address: "270 Rama VI Rd, Ratchathewi", coordinate: CLLocationCoordinate2D(latitude: 13.7650, longitude: 100.5310), isAvailable: true, totalSpots: 200, availableSpots: 45, pricePerHour: 20.0, type: .hospital),
        ParkingSpace(name: "Samitivej Hospital", address: "133 Sukhumvit 49, Khlong Tan Nuea", coordinate: CLLocationCoordinate2D(latitude: 13.7220, longitude: 100.5810), isAvailable: true, totalSpots: 160, availableSpots: 52, pricePerHour: 25.0, type: .hospital),
        ParkingSpace(name: "Kasetsart University", address: "50 Ngamwongwan Rd, Chatuchak", coordinate: CLLocationCoordinate2D(latitude: 13.8505, longitude: 100.5700), isAvailable: true, totalSpots: 300, availableSpots: 128, pricePerHour: 15.0, type: .university),
        ParkingSpace(name: "Thammasat University", address: "2 Prachan Rd, Phra Nakhon", coordinate: CLLocationCoordinate2D(latitude: 13.7577, longitude: 100.4868), isAvailable: true, totalSpots: 220, availableSpots: 95, pricePerHour: 10.0, type: .university),
        ParkingSpace(name: "BTS Mo Chit Parking", address: "Phahonyothin Rd, Chatuchak", coordinate: CLLocationCoordinate2D(latitude: 13.8025, longitude: 100.5536), isAvailable: false, totalSpots: 50, availableSpots: 0, pricePerHour: 30.0, type: .transit),
        ParkingSpace(name: "MRT Chatuchak Park", address: "Kamphaeng Phet 2 Rd, Chatuchak", coordinate: CLLocationCoordinate2D(latitude: 13.7999, longitude: 100.5500), isAvailable: true, totalSpots: 70, availableSpots: 15, pricePerHour: 25.0, type: .transit),
        ParkingSpace(name: "Lumpini Park Lot", address: "Rama IV Rd, Pathum Wan", coordinate: CLLocationCoordinate2D(latitude: 13.7310, longitude: 100.5418), isAvailable: true, totalSpots: 60, availableSpots: 18, pricePerHour: 20.0, type: .outdoor)
    ]

    static func makeTime(hour: Int, minute: Int, daysAgo: Int) -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let day = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day)!
    }

    static let sampleHistory = [
        Reservation(parkingName: "CentralWorld Parking", date: Date().addingTimeInterval(-86400 * 1), startTime: makeTime(hour: 13, minute: 0, daysAgo: 1), durationHours: 3, totalCost: 120.0, status: .active),
        Reservation(parkingName: "Kasetsart University", date: Date().addingTimeInterval(-86400 * 3), startTime: makeTime(hour: 8, minute: 30, daysAgo: 3), durationHours: 5, totalCost: 75.0, status: .completed),
        Reservation(parkingName: "Siam Paragon Parking", date: Date().addingTimeInterval(-86400 * 5), startTime: makeTime(hour: 17, minute: 0, daysAgo: 5), durationHours: 2, totalCost: 120.0, status: .completed),
        Reservation(parkingName: "Terminal 21 Asok", date: Date().addingTimeInterval(-86400 * 8), startTime: makeTime(hour: 10, minute: 0, daysAgo: 8), durationHours: 4, totalCost: 180.0, status: .completed),
        Reservation(parkingName: "Silom Office Tower", date: Date().addingTimeInterval(-86400 * 10), startTime: makeTime(hour: 9, minute: 0, daysAgo: 10), durationHours: 8, totalCost: 400.0, status: .cancelled),
        Reservation(parkingName: "ICON SIAM Parking", date: Date().addingTimeInterval(-86400 * 14), startTime: makeTime(hour: 14, minute: 30, daysAgo: 14), durationHours: 3, totalCost: 150.0, status: .completed)
    ]
}

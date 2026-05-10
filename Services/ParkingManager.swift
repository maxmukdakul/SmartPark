//
//  ParkingManager.swift
//  SmartPark
//
//  Created by Max on 9/5/2569 BE.
//

import Foundation
import Observation
import UserNotifications
import MapKit
import CoreLocation

@Observable
class ParkingManager {
    var parkingSpaces: [ParkingSpace] = MockData.sampleParkingSpaces
    var reservations: [Reservation] = MockData.sampleHistory
    var notificationsEnabled: Bool = true
    var favoriteSpaceIDs: Set<UUID> = []
    var lastBookedSpaceID: UUID?
    var lastCancellationTime: Date?

    private let locationManager = CLLocationManager()

    init() {
        requestNotificationPermission()
        locationManager.requestWhenInUseAuthorization()
        expireOldReservations()
    }

    var activeReservations: [Reservation] {
        reservations.filter { $0.status == .active }
    }

    func expireOldReservations() {
        let now = Date()
        var expiredAny = false
        for i in reservations.indices {
            if reservations[i].status == .active && now >= reservations[i].endTime {
                reservations[i].status = .completed
                expiredAny = true
            }
        }
        if expiredAny && activeReservations.isEmpty {
            lastBookedSpaceID = nil
        }
    }

    var pastReservations: [Reservation] {
        reservations.filter { $0.status != .active }
    }

    var favoriteSpaces: [ParkingSpace] {
        parkingSpaces.filter { favoriteSpaceIDs.contains($0.id) }
    }

    var bookedSpace: ParkingSpace? {
        guard let active = activeReservations.first else { return nil }
        return parkingSpaces.first { $0.name == active.parkingName }
    }

    var isOnCooldown: Bool {
        guard let lastCancel = lastCancellationTime else { return false }
        return Date().timeIntervalSince(lastCancel) < 3600
    }

    var cooldownRemainingMinutes: Int {
        guard let lastCancel = lastCancellationTime else { return 0 }
        let elapsed = Date().timeIntervalSince(lastCancel)
        return max(0, Int(ceil((3600 - elapsed) / 60)))
    }

    // MARK: - Booking

    func bookSpace(_ space: ParkingSpace, duration: Int, startTime: Date) {
        let reservation = Reservation(
            parkingName: space.name,
            date: Date(),
            startTime: startTime,
            durationHours: duration,
            totalCost: space.pricePerHour * Double(duration),
            status: .active
        )
        reservations.insert(reservation, at: 0)
        lastBookedSpaceID = space.id

        if notificationsEnabled {
            scheduleExpirationReminder(for: reservation)
        }
    }

    func cancelReservation(id: UUID) {
        guard let index = reservations.firstIndex(where: { $0.id == id }) else { return }
        guard reservations[index].canCancel else { return }
        reservations[index].status = .cancelled
        lastBookedSpaceID = nil
        lastCancellationTime = Date()
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [id.uuidString]
        )
    }

    // MARK: - Favorites

    func isFavorite(_ space: ParkingSpace) -> Bool {
        favoriteSpaceIDs.contains(space.id)
    }

    func toggleFavorite(_ space: ParkingSpace) {
        if favoriteSpaceIDs.contains(space.id) {
            favoriteSpaceIDs.remove(space.id)
        } else {
            favoriteSpaceIDs.insert(space.id)
        }
    }

    // MARK: - Navigation

    func openDirections(to space: ParkingSpace) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: space.coordinate))
        mapItem.name = space.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    // MARK: - Notifications

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    private func scheduleExpirationReminder(for reservation: Reservation) {
        let content = UNMutableNotificationContent()
        content.title = "Parking Expiring Soon"
        content.body = "Your parking at \(reservation.parkingName) expires in 15 minutes."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: reservation.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

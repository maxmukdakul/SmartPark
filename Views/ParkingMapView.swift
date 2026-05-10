//
//  ParkingMapView.swift
//  SmartPark
//
//  Created by Max on 9/5/2569 BE.
//

import SwiftUI
import MapKit

struct ParkingMapView: View {
    @Environment(ParkingManager.self) private var parkingManager
    @State private var position: MapCameraPosition = .userLocation(
        fallback: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 13.7563, longitude: 100.5018),
            span: MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
        ))
    )
    @State private var selectedSpace: ParkingSpace?
    @State private var searchText = ""
    @State private var selectedType: ParkingType?

    var filteredSpaces: [ParkingSpace] {
        parkingManager.parkingSpaces.filter { space in
            let matchesSearch = searchText.isEmpty ||
                space.name.localizedCaseInsensitiveContains(searchText) ||
                space.address.localizedCaseInsensitiveContains(searchText)
            let matchesType = selectedType == nil || space.type == selectedType
            return matchesSearch && matchesType
        }
    }

    private func showAllSpaces() {
        let coords = filteredSpaces.map(\.coordinate)
        guard !coords.isEmpty else { return }
        let minLat = coords.map(\.latitude).min()!
        let maxLat = coords.map(\.latitude).max()!
        let minLon = coords.map(\.longitude).min()!
        let maxLon = coords.map(\.longitude).max()!
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.5, 0.05),
            longitudeDelta: max((maxLon - minLon) * 1.5, 0.05)
        )
        withAnimation(.easeInOut(duration: 0.6)) {
            position = .region(MKCoordinateRegion(center: center, span: span))
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $position) {
                    UserAnnotation()

                    ForEach(filteredSpaces) { space in
                        let isBooked = parkingManager.bookedSpace?.id == space.id
                        Annotation(space.name, coordinate: space.coordinate) {
                            if isBooked {
                                BookedPinView(space: space) {
                                    selectedSpace = space
                                }
                            } else {
                                ParkingPinView(
                                    space: space,
                                    isFavorite: parkingManager.isFavorite(space)
                                ) {
                                    selectedSpace = space
                                }
                            }
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }

                VStack(spacing: 10) {
                    if let active = parkingManager.activeReservations.first {
                        ActiveBookingBanner(reservation: active) {
                            if let space = parkingManager.bookedSpace {
                                withAnimation(.easeInOut(duration: 0.8)) {
                                    position = .region(MKCoordinateRegion(
                                        center: space.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                    ))
                                }
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Circle().fill(.green).frame(width: 8, height: 8)
                            Text("Available")
                        }
                        HStack(spacing: 6) {
                            Circle().fill(.red).frame(width: 8, height: 8)
                            Text("Full")
                        }
                        HStack(spacing: 6) {
                            Circle().fill(.blue).frame(width: 8, height: 8)
                            Text("Booked")
                        }
                        Spacer()
                        Text("\(filteredSpaces.filter(\.isAvailable).count) open")
                            .fontWeight(.medium)
                            .foregroundStyle(.green)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.ultraThickMaterial)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
            }
            .navigationTitle("Find Parking")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .searchable(text: $searchText, prompt: "Search by name or address")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showAllSpaces()
                    } label: {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Menu {
                        Button {
                            selectedType = nil
                        } label: {
                            Label("All Types", systemImage: "square.grid.2x2")
                        }
                        Divider()
                        ForEach(ParkingType.allCases, id: \.self) { type in
                            Button {
                                selectedType = type
                            } label: {
                                Label(type.rawValue, systemImage: type.icon)
                            }
                        }
                    } label: {
                        Image(systemName: selectedType == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                            .foregroundStyle(selectedType == nil ? Color.primary : Color.yellow)
                    }
                }
            }
            .sheet(item: $selectedSpace) { space in
                if parkingManager.bookedSpace?.id == space.id,
                   let reservation = parkingManager.activeReservations.first(where: { $0.parkingName == space.name }) {
                    ActiveBookingDetailView(space: space, reservation: reservation)
                } else {
                    ReservationDetailView(space: space)
                }
            }
            .onChange(of: parkingManager.lastBookedSpaceID) { _, newID in
                if let id = newID,
                   let space = parkingManager.parkingSpaces.first(where: { $0.id == id }) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        position = .region(MKCoordinateRegion(
                            center: space.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        ))
                    }
                } else if newID == nil {
                    showAllSpaces()
                }
            }
        }
    }
}

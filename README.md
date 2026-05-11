# SmartPark — Smart Parking Finder

A mobile iOS application for finding, reserving, and managing parking spaces across Bangkok in real-time. Built with SwiftUI for the Mobile Development course at Kasetsart University.

## Developers

- **Chanotai Mukdakul** (6610545782) — chanotai.m@ku.th
- **Thanutham Chonsongkram** (6510545438) — thanutham.c@ku.th

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Features

### Authentication
- Google and Apple sign-in (simulated)
- Per-account data separation — each account keeps its own bookings, favorites, and history
- Animated splash screen

### Interactive Map
- 15 parking locations across Bangkok (malls, offices, hospitals, universities, transit, outdoor)
- Color-coded pins: green (available), red (full), blue (your booking with pulsing animation)
- Search by name or address
- Filter by parking type
- "Show All" button to zoom out and view all locations
- User GPS location with location button to re-center
- Auto-zoom to booked location after booking

### Booking System
- Select date, time, and duration (1–12 hours)
- Real-time price calculation
- Capacity bar showing occupancy rate
- Booking confirmation with animated success screen
- Active booking banner on map — tap car icon to zoom to booking

### Cancellation
- Cancel from map banner, booking detail, or history
- 1-hour restriction: cannot cancel within 1 hour of start time
- 1-hour cooldown: cannot make a new booking for 1 hour after cancelling (anti-spam)

### Navigation
- "Get Directions" button opens Apple Maps with driving directions

### Favorites
- Star/unstar parking locations
- Favorite count shown on map pins and in profile stats

### History
- Filter by All / Active / Completed / Cancelled
- Detailed reservation cards with date, time, duration, cost

### Auto-Expiration
- Active bookings automatically marked as "Completed" when end time passes
- Checked on app launch and when returning to foreground

### Notifications
- Local push notification 15 minutes before parking expires
- Toggle on/off in profile settings

### Profile
- Stats grid: total bookings, active, favorites, total spent
- Notification settings
- App info with version, developers, university
- Sign out with confirmation

## Tech Stack

| Technology | Purpose |
|---|---|
| SwiftUI | UI framework |
| MapKit | Map, annotations, directions |
| CoreLocation | GPS location permissions |
| UserNotifications | Local push notifications |
| Observation | State management (`@Observable`) |

## Project Structure

```
SmartPark/
├── SmartParkApp.swift              # App entry point
├── Views/
│   ├── ParkingMapView.swift        # Main map screen
│   ├── MapPinViews.swift           # Map pin components
│   ├── ActiveBookingBanner.swift   # Active booking overlay
│   ├── ActiveBookingDetailView.swift
│   ├── ReservationDetailView.swift # Booking form + success
│   ├── ReservationCard.swift       # History card component
│   ├── HistoryLogView.swift        # Booking history screen
│   ├── ProfileView.swift           # User profile screen
│   ├── LoginView.swift             # Login screen
│   ├── GoogleAccountPicker.swift   # Account selection sheet
│   ├── SplashView.swift            # Splash animation
│   ├── MainTabView.swift           # Tab bar navigation
│   └── SharedComponents.swift      # Reusable UI components
├── Models/
│   ├── ParkingSpace.swift          # ParkingSpace + ParkingType
│   ├── Reservation.swift           # Reservation + ReservationStatus
│   ├── UserProfile.swift           # User profile model
│   └── MockData.swift              # Sample parking & history data
└── Services/
    ├── ParkingManager.swift        # Booking, favorites, navigation, notifications
    └── AuthManager.swift           # Authentication state management
```

## Architecture

- **Pattern**: MVVM-like with SwiftUI's `@Observable` and `@Environment`
- **State Management**: Observation framework — `ParkingManager` and `AuthManager` as `@Observable` classes injected via `.environment()`
- **Data Flow**: `@State` in App → `.environment()` → `@Environment` in views
- **Per-Account Storage**: In-memory dictionary keyed by user email, saving/loading on sign-out/sign-in

## Setup

1. Open `SmartPark.xcodeproj` in Xcode
2. Select an iPhone simulator or connected device
3. Build and run (Cmd + R)
4. If using simulator, set a simulated location: **Debug > Simulate Location > Custom Location** (Bangkok: 13.7563, 100.5018)

## License

This project was created for educational purposes as part of the Mobile Development course at Kasetsart University.

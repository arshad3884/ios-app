//
//  LocationManager.swift
//  mango
//
//  Created by Leo on 23.04.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI
import CoreLocation

@Observable class LocationManager: NSObject, CLLocationManagerDelegate {
    private(set) var autorizationStatus: LocationAutorizationStatus = .none
    private let locationManager = CLLocationManager()

    func requestLocationAutorizationStatus() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        checkLocationAutorizationStatus(status: locationManager.authorizationStatus)
    }

    private func checkLocationAutorizationStatus(status: CLAuthorizationStatus) {
        DispatchQueue.global().async {
            switch status { // check authorizationStatus instead of locationServicesEnabled()
            case .notDetermined, .authorizedWhenInUse:
                self.locationManager.requestAlwaysAuthorization()
                self.setAutorizationStatus(.requested)
            case .restricted, .denied:
                self.setAutorizationStatus(.declined)
            case .authorizedAlways:
                break
            @unknown default:
                self.setAutorizationStatus(.declined)
            }
        }
    }
    
    public func startListeningUserLocationUpdates() {
        locationManager.requestLocation()
    }
    
    public func stopListeningUserLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    private func updateUserCoordinates(_ location: CLLocation?) {
        DispatchQueue.main.async {
            if location != nil {
                User.setUserLocation(location)
                self.setAutorizationStatus(.autorized)
            } else {
                self.setAutorizationStatus(.declined)
            }
        }
    }
    
    private func setAutorizationStatus(_ status: LocationAutorizationStatus) {
        if status == .autorized,  let location = User.storedLocation {
            Task { 
                await SearchFilters.shared.update(coordinates: location.coordinate)
                await MainActor.run {
                    self.autorizationStatus = status
                }
            }
        } else {
            if Thread.isMainThread {
                self.autorizationStatus = status
            } else {
                DispatchQueue.main.async {
                    self.autorizationStatus = status
                }
            }
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager,
                                  didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        debugPrint("⛳️ ===>>>> user location coordinates: \(location.coordinate)")
        
        self.updateUserCoordinates(location)
        self.stopListeningUserLocationUpdates()
    }

    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAutorizationStatus(status: manager.authorizationStatus)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(" =====>>>> ", String(describing: error))
    }
    
    deinit {
        stopListeningUserLocationUpdates()
    }
}

extension LocationManager {
    enum LocationAutorizationStatus {
        case none
        case autorized
        case declined
        case requested
    }
}

extension LocationManager {
    struct AllowLocationPopover: View {
        
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            InfoFillLabel(text: "To enjoy full experience, allow access your location from Settings app.")
                .onTapGesture {
                    dismiss()
                    if let openSettingsURLString = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(openSettingsURLString)
                    }
                }
        }
    }
}

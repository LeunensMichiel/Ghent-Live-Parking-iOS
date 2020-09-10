import Foundation
import CoreLocation

final class LocationService {
    static let shardedLocationService = LocationService()
    static let locationManager = CLLocationManager()

    func checkLocationServices() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorisation()
            return true
        }
        return false
    }
    
    func setupLocationManager() {
        LocationService.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorisation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            LocationService.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            LocationService.locationManager.startUpdatingLocation()
            break
        @unknown default:
            break
        }
    }
}

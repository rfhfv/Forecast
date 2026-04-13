import CoreLocation

protocol LocationServiceProtocol {
    func fetchLocation() async throws -> LocationCoordinate
    func getCityName(from coordinate: LocationCoordinate) async -> String 
}

final class LocationService: NSObject, LocationServiceProtocol {
    struct Dependencies {
        let locationManager: CLLocationManager
        
        static func makeDefault() -> Dependencies {
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyBest
            return Dependencies(locationManager: manager)
        }
    }
    
    private let dependencies: Dependencies
    private var continuation: CheckedContinuation<LocationCoordinate, Error>?
    
    init(dependencies: Dependencies = .makeDefault()) {
        self.dependencies = dependencies
        super.init()
        dependencies.locationManager.delegate = self
    }
    
    func fetchLocation() async throws -> LocationCoordinate {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let status = dependencies.locationManager.authorizationStatus
            
            switch status {
            case .notDetermined:
                dependencies.locationManager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                continuation.resume(throwing: LocationError.denied)
            case .authorizedAlways, .authorizedWhenInUse:
                dependencies.locationManager.startUpdatingLocation()
            @unknown default:
                continuation.resume(throwing: LocationError.unknown)
            }
        }
    }
    
    func getCityName(from coordinate: LocationCoordinate) async -> String {
        let clLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(clLocation)
            guard let placemark = placemarks.first else {
                return Constants.Text.unknownLocation
            }
            
            let city = placemark.locality ?? placemark.administrativeArea ?? ""
            let country = placemark.country ?? ""
            
            if city.isEmpty && country.isEmpty {
                return Constants.Text.unknownLocation
            } else if city.isEmpty {
                return country
            } else if country.isEmpty {
                return city
            } else {
                return "\(city), \(country)"
            }
        } catch {
            return Constants.Text.defaultCity
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        continuation?.resume(returning: LocationCoordinate(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude)
        )
        continuation = nil
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: LocationError.unknown)
        continuation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            continuation?.resume(throwing: LocationError.denied)
            continuation = nil
        default:
            break
        }
    }
}

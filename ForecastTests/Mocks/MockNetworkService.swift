import Foundation
@testable import Forecast

final class MockNetworkService: NetworkServiceProtocol {
    var result: Result<ForecastResponse, Error>!
    
    func fetchForecast(for coordinates: LocationCoordinate) async throws -> ForecastResponse {
        return try result.get()
    }
}

final class MockLocationService: LocationServiceProtocol {
    var locationResult: Result<LocationCoordinate, Error>!
    var cityName: String = "Test City"
    
    func fetchLocation() async throws -> LocationCoordinate {
        return try locationResult.get()
    }
    
    func getCityName(from coordinate: LocationCoordinate) async -> String {
        return cityName
    }
}

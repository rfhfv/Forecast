import Foundation

protocol NetworkServiceProtocol {
    func fetchForecast(for coordinates: LocationCoordinate) async throws -> ForecastResponse
}

final class NetworkService: NetworkServiceProtocol {
    struct Dependencies {
        let session: URLSession
        let decoder: JSONDecoder
        
        static func makeDefault() -> Dependencies {
            let decoder = JSONDecoder()
            return Dependencies(session: .shared, decoder: decoder)
        }
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies = .makeDefault()) {
        self.dependencies = dependencies
    }
    
    func fetchForecast(for coordinates: LocationCoordinate) async throws -> ForecastResponse {
        guard let url = NetworkEndpoint.API.url(coordinates, days: Constants.Network.forecastDays) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await dependencies.session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw  NetworkError.invalidResponse
        }
        
        do {
            let forecast = try dependencies.decoder.decode(ForecastResponse.self, from: data)
            return forecast
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

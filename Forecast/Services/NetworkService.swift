import Foundation

final class NetworkService {
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    func fetchForecast(for coordinates: LocationCoordinate) async throws -> ForecastResponse {
        guard let url = NetworkEndpoint.API.url(coordinates, days: Constants.Network.forecastDays) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw  NetworkError.invalidResponse
        }
        
        do {
            let forecast = try decoder.decode(ForecastResponse.self, from: data)
            return forecast
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

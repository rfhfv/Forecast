import Foundation

protocol NetworkServiceProtocol {
    func fetchForecast(for coordinates: LocationCoordinate) async throws -> ForecastResponse
}

final class NetworkService {
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
}

extension NetworkService: NetworkServiceProtocol {
    func fetchForecast(for coordinates: LocationCoordinate) async throws -> ForecastResponse {
        guard let url = NetworkEndpoint.API.url(coordinates, days: Constants.Network.forecastDays) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw  NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }
            
            do {
                let forecast = try decoder.decode(ForecastResponse.self, from: data)
                return forecast
            } catch {
                throw NetworkError.decodingError(error)
            }
        }
        catch  let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}

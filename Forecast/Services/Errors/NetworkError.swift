import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Ошибка URL"
        case .invalidResponse: return "Ошибка получения данных"
        case .httpError(let statusCode): return "Ошибка сервера. Код: \(statusCode)"
        case .decodingError(let error): return "Ошибка декодирования: \(error.localizedDescription)"
        case .unknown(let error): return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
}

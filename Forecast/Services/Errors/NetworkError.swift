import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Ошибка URL"
        case .invalidResponse: return "Ошибка получения данных"
        case .decodingError(let error): return "Ошибка декодирования: \(error.localizedDescription)"
        }
    }
}

import Foundation

struct NetworkEndpoint {
    enum API {
        private static let key = "DAAGSRRUPJ3HRGKZ6AN4PSALU"
        private static let unitGroup = "metric"
        private static let lang = "ru"
        
        static func url(_ coordinates: LocationCoordinate, days: Int) -> URL? {
            var comps = URLComponents()
            comps.scheme = "https"
            comps.host = "weather.visualcrossing.com"
            comps.path = "/VisualCrossingWebServices/rest/services/timeline/\(coordinates.latitude),\(coordinates.longitude)"
            comps.queryItems = [
                URLQueryItem(name: "key", value: key),
                URLQueryItem(name: "unitGroup", value: unitGroup),
                URLQueryItem(name: "days", value: String(max(1, days))),
                URLQueryItem(name: "lang", value: lang)
            ]
            
            return comps.url
        }
    }
}

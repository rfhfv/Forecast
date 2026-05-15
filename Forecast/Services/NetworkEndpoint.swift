import Foundation

struct NetworkEndpoint {
    enum API {
        private static let unitGroup = "metric"
        private static let lang = "ru"
        
        static var keychainManager: KeychainManagerProtocol.Type = KeychainManager.self
        
        static var key: String {
            if let savedKey = keychainManager.load(key: Constants.Network.stringAPIKey) {
                return savedKey
            }
            
            guard let key = Bundle.main.object(forInfoDictionaryKey: Constants.Network.stringAPIKey) as? String else {
                fatalError(Constants.Network.keyNotFound)
            }
            
            KeychainManager.save(key: Constants.Network.stringAPIKey, data: key)
            return key
        }
        
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

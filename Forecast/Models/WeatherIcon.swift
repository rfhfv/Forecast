import UIKit

enum WeatherIcon: String {
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case cloudy
    case fog
    case hail
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case rainSnowShowersDay = "rain-snow-showers-day"
    case rainSnowShowersNight = "rain-snow-showers-night"
    case rainSnow = "rain-snow"
    case rain
    case showersDay = "showers-day"
    case showersNight = "showers-night"
    case sleet
    case snowShowersDay = "snow-showers-day"
    case snowShowersNight = "snow-showers-night"
    case snow
    case thunderRain = "thunder-rain"
    case thunderShowersDay = "thunder-showers-day"
    case thunderShowersNight = "thunder-showers-night"
    case thunder
    case wind
    
    var systemName: String {
        switch self {
        case .clearDay: return "sun.min"
        case .clearNight: return "moon"
        case .cloudy: return "cloud"
        case .fog: return "cloud.fog"
        case .hail: return "cloud.hail"
        case .partlyCloudyDay: return "cloud.sun"
        case .partlyCloudyNight: return "cloud.moon"
        case .rainSnowShowersDay,
                .rainSnowShowersNight,
                .rainSnow,
                .sleet:
            return "cloud.sleet"
        case .rain:
            return "cloud.drizzle"
        case .showersDay:
            return "cloud.sun.rain"
        case .showersNight:
            return "cloud.moon.rain"
        case .snowShowersDay,
                .snowShowersNight,
                .snow:
            return "cloud.snow"
        case .thunderRain:
            return "cloud.bolt.rain"
        case .thunderShowersDay:
            return "cloud.sun.bolt"
        case .thunderShowersNight:
            return "cloud.moon.bolt"
        case .thunder:
            return "cloud.bolt"
        case .wind:
            return "wind"
        }
    }
    
    var image: UIImage? {
        UIImage(systemName: systemName)
    }
}

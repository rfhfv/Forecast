import UIKit

enum Constants {
    enum Network {
        static let forecastDays = 14
        static let stringAPIKey = "VisualCrossingAPIKey"
        static let keyNotFound = "API ключ не найден"
    }
    
    enum Text {
        static let defaultCity = "Москва, Россия"
        static let unknownLocation = "Неизвестное место"
        static let connectionError = "Упс! Что-то пошло не так."
        
        static let retry = "Повторить"
        
        static let sunrise = "Восход"
        static let sunset = "Закат"
        static let feelsLike = "Ощущается"
        static let wind = "Ветер"
        static let humidity = "Влажность"
        static let pressure = "Давление"
        static let visibility = "Видимость"
        static let uvIndex = "УФ-индекс"
    }
    
    enum Image {
        enum Size {
            static let small = CGSize(width: 32, height: 26)
        }
        
        enum Name {
            static let sun = "sun.min"
            static let moon = "moon"
        }
    }
    
    enum Layout {
        enum Spacing {
            static let small: CGFloat = 4
            static let medium: CGFloat = 6
            static let large: CGFloat = 14
            static let extraLarge: CGFloat = 50
        }
        
        enum Size {
            static let collectionHeight: CGFloat = 500
            static let button = CGSize(width: 160, height: 50)
            static let cornerRadius: CGFloat = 20
        }
    }
    
    enum Grid {
        enum Size {
            static let itemSize = CGSize(width: 80, height: 75)
        }
        
        enum Spacing {
            static let sectionInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 8)
            
            static let hourlySectionInsets = NSDirectionalEdgeInsets(top: 0, leading: -8, bottom: 14, trailing: 8)
        }
    }
}

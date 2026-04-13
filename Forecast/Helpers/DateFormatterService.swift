import Foundation

protocol DateFormatterServiceProtocol {
    func hour(from string: String) -> Int
    func hourString(from string: String) -> String
    func dayString(from string: String) -> String
    func currentDayString() -> String
}

final class DateFormatterService: DateFormatterServiceProtocol {
    private let hourFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f
    }()
    
    private let shortHourFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    private let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    private let outputDayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "d MMM"
        return f
    }()
    
    private let fullDayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "EEEE, d MMMM"
        return f
    }()
    
    func hour(from string: String) -> Int {
        guard let date = hourFormatter.date(from: string) else { return 0 }
        return Calendar.current.component(.hour, from: date)
    }
    
    func hourString(from string: String) -> String {
        guard let date = hourFormatter.date(from: string) else { return "" }
        return shortHourFormatter.string(from: date)
    }
    
    func dayString(from string: String) -> String {
        guard let date = dayFormatter.date(from: string) else { return "" }
        return outputDayFormatter.string(from: date).capitalized
    }
    
    func currentDayString() -> String {
        fullDayFormatter.string(from: Date()).capitalized
    }
}

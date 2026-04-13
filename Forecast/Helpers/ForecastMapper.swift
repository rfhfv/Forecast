import Foundation

protocol ForecastMapperProtocol {
    func map(response: ForecastResponse, city: String) -> ForecastViewModel
}

final class ForecastMapper: ForecastMapperProtocol {
    private let dateService: DateFormatterServiceProtocol
    
    init(dateService: DateFormatterServiceProtocol) {
        self.dateService = dateService
    }
    
    func map(response: ForecastResponse, city: String) -> ForecastViewModel {
        guard let today = response.days.first else {
            return .empty
        }
        
        return ForecastViewModel(
            current: mapCurrent(today, city: city),
            details: mapDetails(today),
            hourly: mapHourly(response),
            daily: mapDaily(response)
        )
    }
    
    private func mapCurrent(_ day: Day, city: String) -> CurrentForecastViewModel {
        .init(
            city: city,
            dateTime: dateService.currentDayString(),
            temp: Int(day.temp)
        )
    }
    
    private func mapDetails(_ day: Day) -> ForecastDetailViewModel {
        .init(
            sunrise: day.sunrise,
            sunset: day.sunset,
            feelsLike: Int(day.feelslike),
            wind: Int(day.windspeed),
            humidity: Int(day.humidity),
            pressure: Int(day.pressure),
            visibility: Int(day.visibility),
            uvIndex: Int(day.uvindex)
        )
    }
    
    private func mapHourly(_ response: ForecastResponse) -> [ForecastHourViewModel] {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        let todayHours = response.days.first?.hours ?? []
        let tomorrowHours = response.days.dropFirst().first?.hours ?? []
        
        let filtered = todayHours.filter {
            dateService.hour(from: $0.datetime) >= currentHour
        }
        
        return (filtered + tomorrowHours).map {
            ForecastHourViewModel(
                datetime: dateService.hourString(from: $0.datetime),
                temp: Int($0.temp),
                icon: WeatherIcon(rawValue: $0.icon) ?? .cloudy
            )
        }
    }
    
    private func mapDaily(_ response: ForecastResponse) -> [ForecastDayViewModel] {
        response.days.prefix(Constants.Network.forecastDays).map {
            ForecastDayViewModel(
                dateTime: dateService.dayString(from: $0.datetime),
                tempMax: Int($0.tempmax),
                tempMin: Int($0.tempmin)
            )
        }
    }
}

import Foundation

final class ForecastMapper {
    private let dateService: DateFormatterService
    
    init(dateService: DateFormatterService) {
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
}

private extension ForecastMapper {
    func mapCurrent(_ day: Day, city: String) -> CurrentForecastViewModel {
        .init(
            city: city,
            dateTime: dateService.currentDayString(),
            temp: Int(day.temp)
        )
    }
    
    func mapDetails(_ day: Day) -> ForecastDetailViewModel {
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
    
    func mapHourly(_ response: ForecastResponse) -> [ForecastHourViewModel] {
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
    
    func mapDaily(_ response: ForecastResponse) -> [ForecastDayViewModel] {
        response.days.prefix(Constants.Network.forecastDays).map {
            ForecastDayViewModel(
                dateTime: dateService.dayString(from: $0.datetime),
                tempMax: Int($0.tempmax),
                tempMin: Int($0.tempmin)
            )
        }
    }
}

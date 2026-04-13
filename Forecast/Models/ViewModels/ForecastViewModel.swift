struct ForecastViewModel {
    let current: CurrentForecastViewModel
    let details: ForecastDetailViewModel
    let hourly: [ForecastHourViewModel]
    let daily: [ForecastDayViewModel]
}

extension ForecastViewModel {
    static let empty = ForecastViewModel(
        current: .init(city: "-", dateTime: "-", temp: 0),
        details: .init(
            sunrise: "-", sunset: "-", feelsLike: 0,
            wind: 0, humidity: 0,
            pressure: 0, visibility: 0,
            uvIndex: 0
        ),
        hourly: [],
        daily: []
    )
}

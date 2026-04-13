struct ForecastDetailViewModel {
    let sunrise: String
    let sunset: String
    let feelsLike: Int
    let wind: Int
    let humidity: Int
    let pressure: Int
    let visibility: Int
    let uvIndex: Int
    var detailsCount: Int { toDetailItems().count }
}

extension ForecastDetailViewModel {
    func toDetailItems() -> [DetailItem] {
        return [
            DetailItem(title: Constants.Text.sunrise, value: sunrise),
            DetailItem(title: Constants.Text.sunset, value: sunset),
            DetailItem(title: Constants.Text.feelsLike, value: "\(feelsLike)°"),
            DetailItem(title: Constants.Text.wind, value: "\(wind) км/ч"),
            DetailItem(title: Constants.Text.humidity, value: "\(humidity)%"),
            DetailItem(title: Constants.Text.pressure, value: "\(pressure) hPa"),
            DetailItem(title: Constants.Text.visibility, value: "\(visibility) км"),
            DetailItem(title: Constants.Text.uvIndex, value: "\(uvIndex)")
        ]
    }
}

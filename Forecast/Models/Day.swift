struct Day: Decodable {
    let datetime: String
    let tempmax: Double
    let tempmin: Double
    let temp: Double
    let feelslike: Double
    let humidity: Double
    let windspeed: Double
    let pressure: Double
    let sunrise: String
    let sunset: String
    let visibility: Double
    let uvindex: Double
    let hours: [Hour]
}

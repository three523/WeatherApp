
import Foundation

struct WeatherModel: Codable {
    let timezone: String
    let current: Current
    let hourly: [HourlyWeather]?
    let daily: [DailyWeather]?
}

struct Current: Codable {
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let wind_speed: Double
    let rain: Double?
    let snow: Double?
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct HourlyWeather: Codable {
    let temp: Double
    let rain: Double?
    let snow: Double?
    let weather: [Weather]
    let pop: Double
}

struct DailyWeather: Codable {
    let dt: String
    let temp: String
    let rain: String?
    let snow: String?
    let weather: [Weather]
    
}

struct Temp: Codable {
    let day: String
    let min: String
    let max: String
}
struct FeelsLike: Codable {
    let day: String
}


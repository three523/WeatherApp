
import Foundation

struct CityWeather {
    var cityName: String
    var weather: Weather
}

struct Weather: Codable {
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

struct CurrentWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let windSpeed: Double
    let rain: Rain?
    let snow: Snow?
    let weather: [MainWeather]
    
    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case temp, pressure, humidity, rain, snow, weather
    }
}

struct SummaryCityWeather {
    let cityName: String
    let weather: SummaryCurrentWeather
}

struct SummaryCurrentWeather: Codable {
    let current: SummaryWeather
}

struct SummaryWeather: Codable {
    let temp: Double
    let humidity: Int
    let weather: [MainWeather]
}

struct MainWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct HourlyWeather: Codable {
    let dt: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let windSpeed: Double
    let rain: Rain?
    let snow: Snow?
    let weather: [MainWeather]
    let pop: Double
    
    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case dt, temp, pressure, humidity, rain, snow, weather, pop
    }
}

struct DailyWeather: Codable {
    let dt: Int
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure: Int
    let humidity: Int
    let windSpeed: Double
    let rain: Double?
    let snow: Double?
    let weather: [MainWeather]
    let pop: Double
    
    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case dt, temp, pressure, humidity, rain, snow, weather, pop
    }
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
}
struct FeelsLike: Codable {
    let day: Double
}

struct Rain: Codable {
    let h1: Double
    
    enum CodingKeys: String, CodingKey {
        case h1 = "1h"
    }
}

struct Snow: Codable {
    let h1: Double
    
    enum CodingKeys: String, CodingKey {
        case h1 = "1h"
    }
}


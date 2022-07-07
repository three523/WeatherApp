//
//  TestModel.swift
//  WeatherApp
//
//  Created by apple on 2022/07/07.
//

import Foundation
import RealmSwift

class CityWeather: Object {
    @Persisted(primaryKey: true) var cityName: String
    @Persisted var weather: Weather?
    @Persisted var lastUpdate: Date
    
    convenience init(cityName: String, weather: Weather, lastUpdate: Date) {
        self.init()
        self.cityName = cityName
        self.weather = weather
        self.lastUpdate = lastUpdate
    }
    
}

class Weather: Object, Decodable {
    @Persisted var current: Current?
    @Persisted var hourly: List<HourlyWeather>
    @Persisted var daily: List<DailyWeather>

    enum CodingKeys: String, CodingKey {
        case current, hourly, daily
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current = try values.decode(Current.self, forKey: .current)
        hourly = try values.decode(List<HourlyWeather>.self, forKey: .hourly)
        daily = try values.decode(List<DailyWeather>.self, forKey: .daily)
    }
}

class Current: Object, Decodable {
    @Persisted var temp: Double
    @Persisted var feelsLike: Double
    @Persisted var pressure: Int
    @Persisted var humidity: Int
    @Persisted var windSpeed: Double
    @Persisted var weather: List<MainWeather>

    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case temp, pressure, humidity, rain, snow, weather
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temp = try values.decode(Double.self, forKey: .temp)
        feelsLike = try values.decode(Double.self, forKey: .feelsLike)
        pressure = try values.decode(Int.self, forKey: .pressure)
        humidity = try values.decode(Int.self, forKey: .humidity)
        windSpeed = try values.decode(Double.self, forKey: .windSpeed)
        weather = try values.decode(List<MainWeather>.self, forKey: .weather)

    }
}

class MainWeather: Object, Decodable {
    @Persisted var id: Int
    @Persisted var main: String
    @Persisted var icon: String

    enum CodingKeys: String, CodingKey {
        case id, main, icon
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        main = try values.decode(String.self, forKey: .main)
        icon = try values.decode(String.self, forKey: .icon)
    }
}

class HourlyWeather: Object, Decodable {
    @Persisted var dt: Int
    @Persisted var temp: Double
    @Persisted var feelsLike: Double
    @Persisted var pressure: Int
    @Persisted var humidity: Int
    @Persisted var windSpeed: Double
    @Persisted var weather: List<MainWeather>

    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case dt, temp, pressure, humidity, weather
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dt = try container.decode(Int.self, forKey: .dt)
        temp = try container.decode(Double.self, forKey: .temp)
        feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        pressure = try container.decode(Int.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        weather = try container.decode(List<MainWeather>.self, forKey: .weather)
    }
}

class DailyWeather: Object, Decodable {
    @Persisted var dt: Int
    @Persisted var temp: Temp? = nil
    @Persisted var feelsLike: FeelsLike? = nil
    @Persisted var pressure: Int
    @Persisted var humidity: Int
    @Persisted var windSpeed: Double
    @Persisted var weather: List<MainWeather>
    @Persisted var pop: Double

    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case dt, temp, pressure, humidity, weather, pop
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dt = try container.decode(Int.self, forKey: .dt)
        temp = try container.decode(Temp.self, forKey: .temp)
        feelsLike = try container.decode(FeelsLike.self, forKey: .feelsLike)
        pressure = try container.decode(Int.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        weather = try container.decode(List<MainWeather>.self, forKey: .weather)
        pop = try container.decode(Double.self, forKey: .pop)
    }
}

class Temp: Object, Decodable {
    @Persisted var day: Double
    @Persisted var min: Double
    @Persisted var max: Double

    enum CodingKeys: String, CodingKey {
        case day, min, max
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        day = try container.decode(Double.self, forKey: .day)
        min = try container.decode(Double.self, forKey: .min)
        max = try container.decode(Double.self, forKey: .max)
    }
}

class FeelsLike: Object, Decodable {
    @Persisted var day: Double

    enum CodingKeys: String, CodingKey {
        case day
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        day = try container.decode(Double.self, forKey: .day)
    }
}



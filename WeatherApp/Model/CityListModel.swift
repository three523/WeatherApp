//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by apple on 2022/06/24.
//

import Foundation

struct CityWeather {
    var cityName: String
    var weather: Weather
}

class CityListModel {
    
    private var cityWeatherList: [CityWeather] = [CityWeather]()
    var cityListTableViewReload: () -> Void = {}
    
    private var cityWeatherDetail: CityWeather?
    var weatherDetailTableViewReload: () -> Void = {}
    var weatherDetailCollectionViewReload: () -> Void = {}
    
    let network = Network()
    
    func weatherList() {
        
        var count = 0
        
        for (key, value) in CityLocations {
            let lat = value[0]
            let lon = value[1]
            
            network.getCityWeather(lat: lat, lon: lon, exclude: "minutely,alerts,hourly,daily") { weatherModel in
                self.cityWeatherList.append(CityWeather(cityName: key, weather: weatherModel))
                
                count += 1

                if count == CityLocations.count {
                    DispatchQueue.main.async {
                        self.cityListTableViewReload()
                    }
                }
            }
        }
    }
    
    func getCityListWeather() -> [CityWeather] {
        return cityWeatherList
    }
    
    func getCityWeather(index: Int) -> CityWeather {
        return cityWeatherList[index]
    }
    
    func getCityListCount() -> Int {
        return cityWeatherList.count
    }
    
    func cityListIndexUpdate(index: Int) {
        let cityWeather = cityWeatherList.remove(at: index)
        cityWeatherList.insert(cityWeather, at: 0)
    }
    
    func weatherDetail(cityName: String, completed: @escaping () -> ()) {
        guard let location = CityLocations[cityName] else {
            print("city name does not exist")
            return
        }
        let lat = location[0]
        let lon = location[1]
                
        network.getCityWeather(lat: lat, lon: lon, exclude: "minutely,alerts") { weatherDetail in
            self.cityWeatherDetail = CityWeather(cityName: cityName, weather: weatherDetail)
            DispatchQueue.main.async {
                self.weatherDetailTableViewReload()
                self.weatherDetailCollectionViewReload()
            }
            completed()
        }
    }
    
    func getWeatherDetail() -> CityWeather? {
        guard let cityWeatherDetail = cityWeatherDetail else {
            print("city weather is nil")
            return nil
        }
        return cityWeatherDetail
    }
    
    func getHourWeatherCount() -> Int {
        guard let count = cityWeatherDetail?.weather.hourly?.count else { return 0 }
        return 24
    }
    
    func getHourWeather(index: Int) -> HourlyWeather? {
        guard let hourlyWeather = cityWeatherDetail?.weather.hourly else {
            print("Hour WeatherDetail is nil")
            return nil
        }
        return hourlyWeather[index]
    }
    
    func getDayWeatherCount() -> Int {
        guard let count = cityWeatherDetail?.weather.daily?.count else { return 0 }
        return count
    }
    
    func getDayWeather(index: Int) -> DailyWeather? {
        guard let dailyWeather = cityWeatherDetail?.weather.daily else {
            print("Daily Weather is nil")
            return nil
        }
        return dailyWeather[index]
    }
}

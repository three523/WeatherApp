//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by apple on 2022/06/24.
//

import Foundation
import UIKit



class CityListModel {
    
    private var summaryCityWeatherList: [SummaryCityWeather] = [SummaryCityWeather]()
    var cityListTableViewReload: () -> Void = {}
    
    private var cityWeatherDetail: CityWeather?
    var weatherDetailTableViewReload: () -> Void = {}
    var weatherDetailCollectionViewReload: () -> Void = {}
    
    let network = Network()
    
    func setSummaryWeatherList() {
        
        var count = 0
        
        let start = CFAbsoluteTimeGetCurrent()
        
        for (key, value) in CityLocations {
            let lat = value[0]
            let lon = value[1]
            
            network.getSummaryCityWeather(lat: lat, lon: lon, exclude: "minutely,alerts,hourly,daily") { summaryCurrentWeather in
                self.summaryCityWeatherList.append(SummaryCityWeather(cityName: key, weather: summaryCurrentWeather))
                
                count += 1

                if count == CityLocations.count {
                    print(CFAbsoluteTimeGetCurrent() - start)
                    DispatchQueue.main.async {
                        self.cityListTableViewReload()
                    }
                }
            }
        }
    }
    
    func getSummaryCityListWeather() -> [SummaryCityWeather] {
        return summaryCityWeatherList
    }
    
    func getSummaryCityWeather(index: Int) -> SummaryCityWeather {
        return summaryCityWeatherList[index]
    }
    
    func getSummaryCityListCount() -> Int {
        return summaryCityWeatherList.count
    }
    
    func setWeatherDetail(cityName: String, completed: @escaping () -> ()) {
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
    
    func setWeatherDetail(cityName: String) {
        guard let location = CityLocations[cityName] else {
            print("city name does not exist")
            return
        }
        let lat = location[0]
        let lon = location[1]
                
        network.getCityWeather(lat: lat, lon: lon, exclude: "minutely,alerts") { weatherDetail in
            self.cityWeatherDetail = CityWeather(cityName: cityName, weather: weatherDetail)
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
        if cityWeatherDetail == nil { return 0 }
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
        guard let count = cityWeatherDetail?.weather.daily.count else { return 0 }
        return count
    }
    
    func getDayWeather(index: Int) -> DailyWeather? {
        guard let dailyWeather = cityWeatherDetail?.weather.daily else {
            print("Daily Weather is nil")
            return nil
        }
        return dailyWeather[index]
    }
    
    func getIconImage(iconName: String) -> UIImage {
        var iconName = iconName
        if iconName.last == "n" {
            iconName.removeLast()
            iconName = iconName + "d"
        }
        guard let image = UIImage(named: iconName) else {return UIImage(systemName: "xmark")!}
        return  image
    }
    
}

//
//  Network.swift
//  WeatherApp
//
//  Created by apple on 2022/06/24.
//

import Foundation

class Network {
    
    let baseUrl: String = "https://api.openweathermap.org/data/3.0/onecall?"
    let session = URLSession.shared
    
    func getCityWeather(lat: String, lon: String, exclude: String, completion: @escaping (Weather) -> ()) {
        
        let urlString = baseUrl + "lat=\(lat)" + "&lon=\(lon)" + "&exclude=\(exclude)" + "&units=metric" + "&appid=\(APIKEY)"
        
       
        guard let url = URL(string: urlString) else {
            print("url is nil")
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data is nil")
                return
            }

            let decoder = JSONDecoder()
            

            do {
                let weather: Weather = try decoder.decode(Weather.self, from: data)
                completion(weather)
            } catch let e {
                print(e.localizedDescription)
            }
        }.resume()
    }
    
    func getSummaryCityWeather(lat: String, lon: String, exclude: String, completion: @escaping (SummaryCurrentWeather) -> ()) {
        
        let urlString = baseUrl + "lat=\(lat)" + "&lon=\(lon)" + "&exclude=\(exclude)" + "&units=metric" + "&appid=\(APIKEY)"
        
       
        guard let url = URL(string: urlString) else {
            print("url is nil")
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data is nil")
                return
            }

            let decoder = JSONDecoder()
            
            do {
                let summaryCurrentWeather: SummaryCurrentWeather = try decoder.decode(SummaryCurrentWeather.self, from: data)
                completion(summaryCurrentWeather)
            } catch let e {
                print(e.localizedDescription)
            }
        }.resume()
    }
    
}

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
    
    func getWeatherData<T: Codable>(lat: String, lon: String, exclude: String, type: T.Type, completion: @escaping (T) -> ()) {
        
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
                let summaryCurrentWeather = try decoder.decode(T.self, from: data)
                completion(summaryCurrentWeather)
            } catch let e {
                print(e.localizedDescription)
            }
        }.resume()
    }
    
}

//
//  Network.swift
//  WeatherApp
//
//  Created by apple on 2022/06/24.
//

import Foundation

class Netwokr {
    
    let baseUrl: String = "https://api.openweathermap.org/data/3.0/onecall?"
    
    func getWeather(lat: String, lon: String, exclude: String, completion: @escaping (WeatherModel) -> ()) {
        
        let urlString = baseUrl + "lat=\(lat)" + "&lon=\(lon)" + "&exclude=\(exclude)" + "&units=metric" + "&appid=\(APIKEY)"
        
        guard let url = URL(string: urlString) else {
            print("url is nil")
            return
        }
        
        let session = URLSession.shared
        let datatask = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data is nil")
                return
            }
                        
            guard let printJsonString = String(data: data, encoding: .utf8) else { return }
                                
            let decoder = JSONDecoder()
            
            do {
                let weatherModel: WeatherModel = try decoder.decode(WeatherModel.self, from: data)
                
                completion(weatherModel)
            } catch {
                print("Error Decoder")
            }
        }
        datatask.resume()
    }
}

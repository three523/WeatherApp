//
//  ViewController.swift
//  WeatherApp
//
//  Created by apple on 2022/06/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityListTableView: UITableView!
    let imageView = UIImageView()
    
    let network = Netwokr()
        
    override func viewDidLoad() {
        
        let nibName = UINib(nibName: "CityListCell", bundle: nil)

        var count = 0
        
//        let url = URL(string: "https://openweathermap.org/img/wn/01d.png")
//        do {
//            let data = try Data(contentsOf: url!)
//            imageView.image = UIImage(data: data)!
//        } catch {
//            print("ImageLoad Error")
//        }
//
//        view.addSubview(imageView)
//        imageView.frame.size = CGSize(width: 100, height: 100)
//        imageView.center = view.center

        
        for (key, value) in cityCoordinate {
            let lat = value[0]
            let lon = value[1]
            network.getWeather(lat: lat, lon: lon, exclude: "minutely,alerts,hourly,daily") { weatherModel in
                CityListViewModel.cityWeatherList.append(CityWeather(cityName: key, weather: weatherModel))
                count += 1

                if count == cityCoordinate.count {
                    DispatchQueue.main.async {
                        self.cityListTableView.reloadData()
                    }
                }
            }
        }
        
        super.viewDidLoad()
        
        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        cityListTableView.register(nibName, forCellReuseIdentifier: "WeatherCell")
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CityListViewModel.cityWeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? CityListCell else {
            return UITableViewCell()
        }
        
        let cityWeather = CityListViewModel.cityWeatherList[indexPath.row]
        let currentWeather = cityWeather.weather.current
        
        let urlString = "https://openweathermap.org/img/wn/" + currentWeather.weather[0].icon + ".png"
        
        let url = URL(string: urlString)
        
        do {
            let data = try Data(contentsOf: url!)
            cell.weatherIcon.image = UIImage(data: data)!
        } catch {
            print("ImageLoad Error")
        }
        
        cell.cityName.text = cityWeather.cityName
        cell.temp.text = "\(Int(round(currentWeather.temp)))º"
        cell.humidity.text = "\(currentWeather.humidity)%"
        
        
        return cell
    }
    
    
}


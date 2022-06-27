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
    
    let network: Network = Network()
    let weatherIconLoader: WeatherIconLoader = WeatherIconLoader()
    let model: CityListModel = CityListModel()
        
    override func viewDidLoad() {
        
        let nibName = UINib(nibName: "CityListCell", bundle: nil)
        
        model.weatherList()
        model.cityListTableViewReload = cityListTableView.reloadData

        super.viewDidLoad()
        
        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        cityListTableView.register(nibName, forCellReuseIdentifier: "WeatherCell")
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getCityListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? CityListCell else {
            return UITableViewCell()
        }
        
        let cityWeather = model.getCityWeather(index: indexPath.row)
        let currentWeather = cityWeather.weather.current
        
        let iconName = currentWeather.weather[0].icon
        weatherIconLoader.getIconImage(iconName: iconName) { icon in
            DispatchQueue.main.async {
                cell.weatherIcon.image = icon
            }
        }
        
        cell.cityName.text = cityWeather.cityName
        cell.temp.text = "\(Int(round(currentWeather.temp)))º"
        cell.humidity.text = "\(currentWeather.humidity)%"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? CityListCell else { return }
        guard let cityName = cell.cityName.text else { return }
        print("sender: \(cityName)")
        performSegue(withIdentifier: "DetailWeatherSegue", sender: cityName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let weatherDetailVC = segue.destination as? DetailWeatherViewController else { return }
        guard let cityName = sender as? String else { return }
        
//        print("VC:\(weatherDetailVC)")
//        print("sender: \(cityName)")
        
        weatherDetailVC.cityName = cityName
    }
    
}


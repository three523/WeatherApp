//
//  ViewController.swift
//  WeatherApp
//
//  Created by apple on 2022/06/23.
//

import UIKit

protocol TableReloadProtocol: class {
    func tableReload()
}

class ViewController: UIViewController, TableReloadProtocol {

    @IBOutlet weak var cityListTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    let imageView = UIImageView()
    
    let network: Network = Network()
    let weatherIconLoader: WeatherIconLoader = WeatherIconLoader()
    let model: CityListModel = CityListModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "CityListCell", bundle: nil)
        
        model.weatherList()
        model.cityListTableViewReload = cityListTableView.reloadData

        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        cityListTableView.register(nibName, forCellReuseIdentifier: "WeatherCell")
        cityListTableView.backgroundColor = .clear
                
    }
    
    func tableReload() {
        DispatchQueue.main.async {
            self.cityListTableView.reloadData()
        }
    }
    //TODO: 첫화면에 이미지를 넣을지 말지 고민해보기
    func setBackgroundWeatherImage(id: Int, id2: Int) {
        if id == 2 { self.backgroundImageView.image = UIImage(named: "ThunderStom")! }
        else if id == 5 { self.backgroundImageView.image = UIImage(named: "Rain")! }
        else if id == 6 { self.backgroundImageView.image = UIImage(named: "Snow")! }
        else if id == 8 && id2 == 0 { self.backgroundImageView.image = UIImage(named: "Clear")! }
        else if id == 8 { self.backgroundImageView.image = UIImage(named: "Clouds")! }

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
        
        cell.weatherIcon.image = nil
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CityListCell else { return }
        guard let cityName = cell.cityName.text else { return }
        model.cityListIndexUpdate(index: indexPath.row)
        performSegue(withIdentifier: "DetailWeatherSegue", sender: cityName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let weatherDetailVC = segue.destination as? DetailWeatherViewController else { return }
        guard let cityName = sender as? String else { return }
        weatherDetailVC.cityName = cityName
        weatherDetailVC.backgroundImage = backgroundImageView.image
        weatherDetailVC.tableReloadDelegate = self
    }
        
}


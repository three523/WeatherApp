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
    let imageView = UIImageView()
    
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
        model.weatherIconLoader.getIconImage(iconName: iconName) { icon in
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
        let index = indexPath.row
        model.cityListIndexUpdate(index: index)
        performSegue(withIdentifier: "DetailWeatherSegue2", sender: cityName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let weatherDetailVC = segue.destination as? CollectionViewController else { return }
        guard let cityName = sender as? String else { return }
        weatherDetailVC.cityName = cityName
        weatherDetailVC.tableReloadDelegate = self
    }
        
}


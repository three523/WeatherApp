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
let model: CityListModel = CityListModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "CityListCell", bundle: nil)
        
        model.setSummaryWeatherList()
        model.cityListTableViewReload = cityListTableView.reloadData

        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        cityListTableView.register(nibName, forCellReuseIdentifier: "WeatherCell")
        cityListTableView.backgroundColor = .clear
                
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getSummaryCityListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? CityListCell else {
            return UITableViewCell()
        }
        
        let summaryCityWeather = model.getSummaryCityWeather(index: indexPath.row)
        let summaryWeather = summaryCityWeather.weather.current
        
        cell.weatherIcon.image = nil
        
        let iconName = summaryWeather.weather[0].icon
        
        model.weatherIconLoader.getIconImage(iconName: iconName) { icon in
            DispatchQueue.main.async {
                cell.weatherIcon.image = icon
            }
        }
        
        cell.cityName.text = summaryCityWeather.cityName
        cell.temp.text = "\(Int(round(summaryWeather.temp)))º"
        cell.humidity.text = "\(summaryWeather.humidity)%"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CityListCell else { return }
        guard let cityName = cell.cityName.text else { return }
        self.performSegue(withIdentifier: "DetailWeatherSegue", sender: cityName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let weatherDetailVC = segue.destination as? DetailWeatherViewController else { return }
        guard let cityName = sender as? String else { return }
        weatherDetailVC.cityName = cityName
        weatherDetailVC.model = model
    }
        
}


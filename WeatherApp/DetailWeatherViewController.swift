//
//  DetailWeatherViewController.swift
//  WeatherApp
//
//  Created by apple on 2022/06/23.
//

import UIKit

class DetailWeatherViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var hourlyWatherCollectionView: UICollectionView!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var dailyWeatherTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    let model: CityListModel = CityListModel()
    let weatherIconLoader: WeatherIconLoader = WeatherIconLoader()
    var cityName: String = ""
    weak var tableReloadDelegate: TableReloadProtocol?
    
    override func loadView() {
        super.loadView()
        
        model.weatherDetailCollectionViewReload = hourlyWatherCollectionView.reloadData
        model.weatherDetailTableViewReload = dailyWeatherTableView.reloadData
        
        model.weatherDetail(cityName: cityName) {
            DispatchQueue.main.async {
                self.viewSetting()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionNibName = UINib(nibName: "TodayHourlyWeatherCell", bundle: nil)
        hourlyWatherCollectionView.register(collectionNibName, forCellWithReuseIdentifier: "HourlyCell")
        
        hourlyWatherCollectionView.delegate = self
        hourlyWatherCollectionView.dataSource = self
        
        let tableNibName = UINib(nibName: "DailyWeatherCell", bundle: nil)
        dailyWeatherTableView.register(tableNibName, forCellReuseIdentifier: "DailyCell")
        
        dailyWeatherTableView.delegate = self
        dailyWeatherTableView.dataSource = self
        
    }
    
    func viewSetting() {
        guard let weatherDeatil = model.getWeatherDetail() else {
            print("get Weather nil")
            return
        }
        guard let currentWeather = weatherDeatil.weather?.current else {return}
        guard let todayWeather = weatherDeatil.weather?.daily.first else {
            print("daily weather nil")
            return
        }
        
        
        hourlyWatherCollectionView.reloadData()
        dailyWeatherTableView

        cityNameLabel.text = weatherDeatil.cityName
        tempLabel.text = "\(Int(round(currentWeather.temp)))º"
        
        let currentWeatherIconName = currentWeather.weather[0].icon
        weatherIconLoader.getIconImage(iconName: currentWeatherIconName) { weatherIcon in
            DispatchQueue.main.async {
                self.currentWeatherIcon.image = weatherIcon
            }
        }

        maxTempLabel.text = "\(Int(round(todayWeather.temp!.max)))º"
        minTempLabel.text = "\(Int(round(todayWeather.temp!.min)))º"
        feelsLikeTempLabel.text = "\(Int(round(currentWeather.feelsLike)))º"
        currentHumidity.text = "\(currentWeather.humidity)%"
        pressureLabel.text = "\(currentWeather.pressure)hPa"
        windSpeedLabel.text = "\(Int(round(currentWeather.windSpeed)))m/s"
        
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        tableReloadDelegate?.tableReload()
        dismiss(animated: true, completion: nil)
    }
    
}

extension DetailWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.getHourWeatherCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as? TodayHourlyWeatherCell else {
            return UICollectionViewCell()
        }
        
        if let hourWeather = model.getHourWeather(index: indexPath.row) {
            let hourString = Date(timeIntervalSince1970: TimeInterval((hourWeather.dt))).hourToString
            
            let hourWeatherIconName = hourWeather.weather[0].icon
            
            weatherIconLoader.getIconImage(iconName: hourWeatherIconName) { weatherIcon in
                DispatchQueue.main.async {
                    cell.hourWeatherIcon.image = weatherIcon
                }
            }
            
            cell.timeLabel.text = hourString
            cell.hourTempLabel.text = "\(Int(round(hourWeather.temp)))º"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.height
        return CGSize(width: height - 20, height: height)
    }
    
}

extension DetailWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getDayWeatherCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as? DailyWeatherCell else {
            return UITableViewCell()
        }
        if let dailyWeather = model.getDayWeather(index: indexPath.row) {
            
            let dailyWeatherIconName = dailyWeather.weather[0].icon
            weatherIconLoader.getIconImage(iconName: dailyWeatherIconName) { weatherIcon in
                DispatchQueue.main.async {
                    cell.dailyWeatherIcon.image = weatherIcon
                }
            }
            
            let dailyString = Date(timeIntervalSince1970: TimeInterval(dailyWeather.dt)).dayToString
            cell.dayLabel.text = dailyString
            cell.dailyMinTemp.text = "\(Int(round(dailyWeather.temp!.min)))º"
            cell.dailyMaxTemp.text = "\(Int(round(dailyWeather.temp!.max)))º"
        }
        
        return cell
    }
    
    
}

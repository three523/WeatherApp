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
    @IBOutlet weak var dayilyWeatherTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var cityName: String = ""
    weak var model: CityListModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionNibName = UINib(nibName: "TodayHourlyWeatherCell", bundle: nil)
        hourlyWatherCollectionView.register(collectionNibName, forCellWithReuseIdentifier: "HourlyCell")
        
        hourlyWatherCollectionView.delegate = self
        hourlyWatherCollectionView.dataSource = self
        
        let tableNibName = UINib(nibName: "DailyWeatherCell", bundle: nil)
        dayilyWeatherTableView.register(tableNibName, forCellReuseIdentifier: "DailyCell")
        
        dayilyWeatherTableView.delegate = self
        dayilyWeatherTableView.dataSource = self
        
        guard let model = model else {
            return
        }
                
        model.weatherDetailCollectionViewReload = hourlyWatherCollectionView.reloadData
        model.weatherDetailTableViewReload = dayilyWeatherTableView.reloadData
        
        model.setWeatherDetail(cityName: cityName, completed: {
            DispatchQueue.main.async {
                self.viewSetting()
            }
        })
        
    }
    
    func viewSetting() {
        guard let model = model,
              let weatherDeatil = model.getWeatherDetail() else {
            print("get Weather nil")
            return
        }
        let currentWeather = weatherDeatil.weather.current
        guard let todayWeather = weatherDeatil.weather.daily.first else {
            print("daily weather nil")
            return
        }

        cityNameLabel.text = weatherDeatil.cityName
        tempLabel.text = "\(Int(round(currentWeather.temp)))º"
        
        let currentWeatherIconName = currentWeather.weather[0].icon
        let currentWeatherIconImage = model.getIconImage(iconName: currentWeatherIconName)
        
        currentWeatherIcon.image = currentWeatherIconImage

        maxTempLabel.text = "\(Int(round(todayWeather.temp.max)))º"
        minTempLabel.text = "\(Int(round(todayWeather.temp.min)))º"
        feelsLikeTempLabel.text = "\(Int(round(currentWeather.feelsLike)))º"
        currentHumidity.text = "\(currentWeather.humidity)%"
        pressureLabel.text = "\(currentWeather.pressure)hPa"
        windSpeedLabel.text = "\(Int(round(currentWeather.windSpeed)))m/s"
        
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension DetailWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = model else { return 0 }
        return model.getHourWeatherCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as? TodayHourlyWeatherCell else {
            return UICollectionViewCell()
        }
        
        if let model = model,
           let hourWeather = model.getHourWeather(index: indexPath.row) {
            let hourString = Date(timeIntervalSince1970: TimeInterval((hourWeather.dt))).hourToString
            
            let hourWeatherIconName = hourWeather.weather[0].icon
                        
            let hourWeatherIconImage = model.getIconImage(iconName: hourWeatherIconName)
            
            cell.hourWeatherIcon.image = hourWeatherIconImage
            
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
        guard let model = model else {return 0}
        return model.getDayWeatherCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as? DailyWeatherCell else {
            return UITableViewCell()
        }
        if let model = model,
           let dailyWeather = model.getDayWeather(index: indexPath.row) {
            
            let dailyWeatherIconName = dailyWeather.weather[0].icon
            let dailyWeatherIconImage = model.getIconImage(iconName: dailyWeatherIconName)
            
            cell.dailyWeatherIcon.image = dailyWeatherIconImage
            let dailyString = Date(timeIntervalSince1970: TimeInterval(dailyWeather.dt)).dayToString
            cell.dayLabel.text = dailyString
            cell.dailyMinTemp.text = "\(Int(round(dailyWeather.temp.min)))º"
            cell.dailyMaxTemp.text = "\(Int(round(dailyWeather.temp.max)))º"
        }
        
        return cell
    }
}

//
//  CurrentWeatherCell.swift
//  WeatherApp
//
//  Created by apple on 2022/06/30.
//

import UIKit

class CurrentWeatherCell: UICollectionViewCell {
    
    static let identifier = "CurrentWeatherCell"
    static let nibName = UINib(nibName: "CurrentWeatherCell", bundle: nil)

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    weak var DetailViewControllerDelegate: DetailViewControllerDismiss?
    var model: CityListModel? = nil {
        didSet {
            viewSetting()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func viewSetting() {
        guard let model = model else { return }
        guard let weatherDeatil = model.getWeatherDetail() else {
            print("get Weather nil")
            return
        }
        let currentWeather = weatherDeatil.weather.current
        guard let todayWeather = weatherDeatil.weather.daily?.first else {
            print("daily weather nil")
            return
        }

        cityNameLabel.text = weatherDeatil.cityName
        currentTempLabel.text = "\(Int(round(currentWeather.temp)))º"
        
        let currentWeatherIconName = currentWeather.weather[0].icon
        model.weatherIconLoader.getIconImage(iconName: currentWeatherIconName) { weatherIcon in
            DispatchQueue.main.async {
                self.currentWeatherIcon.image = weatherIcon
            }
        }

        maxTempLabel.text = "\(Int(round(todayWeather.temp.max)))º"
        minTempLabel.text = "\(Int(round(todayWeather.temp.min)))º"
        feelsLikeLabel.text = "\(Int(round(currentWeather.feelsLike)))º"
        weatherDescription.text = currentWeather.weather[0].main
        currentHumidity.text = "\(currentWeather.humidity)%"
        pressureLabel.text = "\(currentWeather.pressure)hPa"
        windSpeedLabel.text = "\(Int(round(currentWeather.windSpeed)))m/s"
    }
    @IBAction func backButtonClick(_ sender: Any) {
        DetailViewControllerDelegate?.DetailViewControllerDismiss()
    }
    
}

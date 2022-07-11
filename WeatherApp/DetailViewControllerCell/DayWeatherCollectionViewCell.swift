//
//  DayWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by apple on 2022/06/30.
//

import UIKit

class DayWeatherCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    static let identifier = "DayWeatherCollectionViewCell"
    static let nibName = UINib(nibName: "DayWeatherCollectionViewCell", bundle: nil)
    @IBOutlet weak var dailyWeatherTableView: UITableView!
    var model: CityListModel? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nibName = UINib(nibName: "DailyWeatherCell", bundle: nil)
        dailyWeatherTableView.register(nibName, forCellReuseIdentifier: "DailyCell")
        dailyWeatherTableView.delegate = self
        dailyWeatherTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(model?.getDayWeatherCount())
        guard let count = model?.getDayWeatherCount() else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as? DailyWeatherCell else { return UITableViewCell() }
        guard let model = model else {
            return UITableViewCell()
        }
        if let dailyWeather = model.getDayWeather(index: indexPath.row) {
            
            let dailyWeatherIconName = dailyWeather.weather[0].icon
            model.weatherIconLoader.getIconImage(iconName: dailyWeatherIconName) { weatherIcon in
                DispatchQueue.main.async {
                    cell.dailyWeatherIcon.image = weatherIcon
                }
            }
            
            let dailyString = Date(timeIntervalSince1970: TimeInterval(dailyWeather.dt)).dayToString
            cell.dayLabel.text = dailyString
            cell.dailyMinTemp.text = "\(Int(round(dailyWeather.temp.min)))º"
            cell.dailyMaxTemp.text = "\(Int(round(dailyWeather.temp.max)))º"
        }
        
        return cell
    }

}

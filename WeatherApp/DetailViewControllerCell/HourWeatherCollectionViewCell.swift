//
//  TodayHourCollectionViewCell.swift
//  WeatherApp
//
//  Created by apple on 2022/06/30.
//

import UIKit

class HourWeatherCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "HourWeatherCollectionViewCell"
    static let nibName = UINib(nibName: "HourWeatherCollectionViewCell", bundle: nil)
    var hourCollectionView: UICollectionView? = nil
    var model: CityListModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "TodayHourlyWeatherCell", bundle: nil)
        let identifier = "HourlyCell"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        hourCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let hourCollectionView = hourCollectionView else {
            return
        }
        
        contentView.addSubview(hourCollectionView)
        
        hourCollectionView.register(nib, forCellWithReuseIdentifier: identifier)
        hourCollectionView.delegate = self
        hourCollectionView.dataSource = self
        hourCollectionView.showsHorizontalScrollIndicator = false
        
        hourCollectionView.translatesAutoresizingMaskIntoConstraints = false
        hourCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        hourCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        hourCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        hourCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = model else {
            return 0
        }
        return model.getHourWeatherCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as? TodayHourlyWeatherCell else {
            return UICollectionViewCell()
        }
        guard let model = model else {
            return UICollectionViewCell()
        }
        
        if let hourWeather = model.getHourWeather(index: indexPath.row) {
            let hourString = Date(timeIntervalSince1970: TimeInterval((hourWeather.dt))).hourToString
            
            let hourWeatherIconName = hourWeather.weather[0].icon
            
            model.weatherIconLoader.getIconImage(iconName: hourWeatherIconName) { weatherIcon in
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

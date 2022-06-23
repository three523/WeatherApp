//
//  TodayHourWeather.swift
//  WeatherApp
//
//  Created by apple on 2022/06/23.
//

import UIKit

class TodayHourlyWeatherCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hourWeatherIcon: UIImageView!
    @IBOutlet weak var hourTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

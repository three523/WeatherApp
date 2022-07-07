//
//  DailyWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by apple on 2022/06/23.
//

import UIKit

class DailyWeatherCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dailyWeatherIcon: UIImageView!
    @IBOutlet weak var dailyMinTemp: UILabel!
    @IBOutlet weak var dailyMaxTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

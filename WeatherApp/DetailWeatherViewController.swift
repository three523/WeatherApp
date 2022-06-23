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
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var dayilyWeatherTableView: UITableView!
    
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

    }

}

extension DetailWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as? TodayHourlyWeatherCell else {
            return UICollectionViewCell()
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as? DailyWeatherCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}

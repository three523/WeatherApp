//
//  CollectionViewController.swift
//  WeatherApp
//
//  Created by apple on 2022/06/30.
//

import UIKit

protocol DetailViewControllerDismiss: class {
    func DetailViewControllerDismiss()
}

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DetailViewControllerDismiss {
    
    let model: CityListModel = CityListModel()
    var cityName = ""
    weak var tableReloadDelegate: TableReloadProtocol?


    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(CurrentWeatherCell.nibName, forCellWithReuseIdentifier: CurrentWeatherCell.identifier)
        self.collectionView!.register(HourWeatherCollectionViewCell.nibName, forCellWithReuseIdentifier: HourWeatherCollectionViewCell.identifier)
        self.collectionView!.register(DayWeatherCollectionViewCell.nibName, forCellWithReuseIdentifier: DayWeatherCollectionViewCell.identifier)
        self.collectionView.showsVerticalScrollIndicator = false
        
        model.weatherDetail(cityName: cityName) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if model.getDayWeatherCount() == 0 { return 0 }
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let section = indexPath.section
        var cell = UICollectionViewCell()
        
        if section == 0 {
            guard let currentCell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCell.identifier, for: indexPath) as? CurrentWeatherCell else { return UICollectionViewCell() }
            currentCell.model = model
            currentCell.DetailViewControllerDelegate = self
            cell = currentCell
        } else if section == 1 {
            guard let hourCell = collectionView.dequeueReusableCell(withReuseIdentifier: HourWeatherCollectionViewCell.identifier, for: indexPath) as? HourWeatherCollectionViewCell else { return UICollectionViewCell() }
            hourCell.model = model
            cell = hourCell
        } else {
            guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: DayWeatherCollectionViewCell.identifier, for: indexPath) as? DayWeatherCollectionViewCell else { return UICollectionViewCell() }
            dayCell.model = model
            cell = dayCell
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        let width = UIScreen.main.bounds.width - 40
        if section == 0 {
            return CGSize(width: width, height: 300)
        } else if section == 1 {
            return CGSize(width: width, height: 120)
        } else if section == 2 {
            return CGSize(width: width, height: 250)
        } else {
            return CGSize(width: width, height: 600)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            
        }
    }
    
    func DetailViewControllerDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

}

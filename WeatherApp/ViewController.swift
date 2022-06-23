//
//  ViewController.swift
//  WeatherApp
//
//  Created by apple on 2022/06/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityListTableView: UITableView!
        
    override func viewDidLoad() {
        
        let nibName = UINib(nibName: "CityListCell", bundle: nil)

        
        super.viewDidLoad()
        
        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        cityListTableView.register(nibName, forCellReuseIdentifier: "WeatherCell")
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? CityListCell else {
            return UITableViewCell()
        }
        
        cell.weatherIcon.image = UIImage(systemName: "sun.max")
        
        return cell
    }
    
    
}


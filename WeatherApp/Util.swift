//
//  Util.swift
//  WeatherApp
//
//  Created by apple on 2022/06/27.
//

import Foundation
import UIKit

extension Date {
    var hourToString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시"
        return dateFormatter.string(from: self)
    }
    var dayToString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "m.d"
        return dateFormatter.string(from: self)
    }
}

class WeatherIconLoader {
    
    func getIconImage(iconName: String, completed: @escaping (UIImage) -> ()) {
        let urlString = "https://openweathermap.org/img/wn/" + iconName + ".png"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, Response, error in
                if let data = data {
                    guard let image = UIImage(data: data) else {
                        print("image is nil")
                        return
                    }
                    completed(image)
                }
            }.resume()
        }
    }
}

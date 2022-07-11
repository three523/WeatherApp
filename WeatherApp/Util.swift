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
        dateFormatter.dateFormat = "M.d"
        return dateFormatter.string(from: self)
    }
}

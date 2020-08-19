//
//  WeatherHourlyCollectionViewCell.swift
//  IAcademyWeather
//
//  Created by Estique on 8/20/20.
//  Copyright © 2020 Estique. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherHourlyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var weatherHourlyImage: UIImageView!
    
    static let identifier = "WeatherHourlyCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configure(model: Hourly){
        tempLabel.text = "\(Int(model.temp))°"
        let url = URL(string: "http://openweathermap.org/img/wn/\(model.weather[0].icon)@2x.png")
        weatherHourlyImage.contentMode = .scaleAspectFit
        weatherHourlyImage.kf.setImage(with: url)
    }

}

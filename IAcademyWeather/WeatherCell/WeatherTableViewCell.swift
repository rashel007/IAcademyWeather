//
//  WeatherTableViewCell.swift
//  IAcademyWeather
//
//  Created by Estique on 8/19/20.
//  Copyright © 2020 Estique. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var daylabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    
    static let identifier = "WeatherTableViewCell"
       
       static func nib() -> UINib {
           return UINib(nibName: identifier, bundle: nil)
       }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(daylyWeather: Daily){
        minTempLabel.text = "\(Int(daylyWeather.temp.min))°"
        maxTempLabel.text = "\(Int(daylyWeather.temp.max))°"
        let imageurl = URL(string: "http://openweathermap.org/img/wn/\(daylyWeather.weather[0].icon)@2x.png")
        weatherImage.kf.setImage(with: imageurl)
        weatherImage.contentMode = .scaleAspectFit
        daylabel.text = getDayForDate(Date(timeIntervalSince1970: Double(daylyWeather.dt)))
        
    }
    
    
    private func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
    }
    
}

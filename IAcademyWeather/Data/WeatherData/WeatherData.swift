//
//  CurrentWeather.swift
//  IAcademyWeather
//
//  Created by Estique on 8/19/20.
//  Copyright © 2020 Estique. All rights reserved.
//

import Foundation


struct WeatherData : Codable{
    let lon : Double
    let lat : Double
    let timezone: String
    let current : Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let humidity: Int
    let weather: [Weather]
}

struct Hourly : Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let weather: [Weather]
}


struct Weather : Codable{
    let id : Int
    let main: String
    let description: String
    let icon : String
}

struct Daily : Codable{
    let dt : Int
    let sunrise : Int
    let sunset : Int
    let humidity : Int
    let temp: Temp
    let weather: [Weather]
}


struct Temp : Codable{
    let min: Float
    let max: Float
}

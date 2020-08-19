//
//  ViewController.swift
//  IAcademyWeather
//
//  Created by Estique on 8/12/20.
//  Copyright © 2020 Estique. All rights reserved.
//

import UIKit
import CoreLocation

// Location : CoreLocation
// tabbleview
// custom cell: Collectionview
// API / request to get weather data

class ViewController: UIViewController {
    
    @IBOutlet var tableview: UITableView!
    
    var hourlyWeather = [Hourly]()
     var dailyWeather = [Daily]()
    var currentWeather: Current?
    
    
    // location
    let locationManager = CLLocationManager()
    
    var currentLocation : CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableview.backgroundColor = UIColor(red: 33/255.0, green: 117/255.0, blue: 176/255.0, alpha: 1.0)
        
        view.backgroundColor = UIColor(red: 33/255.0, green: 117/255.0, blue: 176/255.0, alpha: 1.0)
        
        // register 2 custom cell fot vertical and horizontal weather report
        
        tableview.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableview.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        tableview.delegate = self
        tableview.dataSource = self
        
        
        // location
        setupLocation()
    }
    
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }


}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty && currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherData()
        }
    }
    
    
    func requestWeatherData() {
       
    
        guard let lat = currentLocation?.coordinate.latitude, let long = currentLocation?.coordinate.longitude else {
            return
        }
        
         print("Current location \(currentLocation?.coordinate.latitude) - \(currentLocation?.coordinate.longitude)")
        
        
        let url = "http://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&appid=0f2b3129d266ea3eded4539543d88604&units=metric"
        
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data , error == nil else {
                print("something went wrong")
                return
            }
            
            
            var json : WeatherData?
            
            do {
                json = try JSONDecoder().decode(WeatherData.self, from: data)
            }catch {
                print("error \(error)")
            }
            
            guard let result = json else{
                return
            }
            
            print("\(result.timezone)")
            DispatchQueue.main.async {
                self.currentWeather = result.current
                self.dailyWeather = result.daily
                self.hourlyWeather = result.hourly
                self.tableview.reloadData()
                self.tableview.tableHeaderView = self.currentHeaderView()
            }
            
        }.resume()
    }
    
    
    private func currentHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 2))
        
        headerView.backgroundColor = UIColor(red: 33/255.0, green: 117/255.0, blue: 176/255.0, alpha: 1.0)
        
        guard let currentWeather = currentWeather else {
            return UIView()
        }
        
        
        let currentLocationlabel = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height/4))
        let tempLabel = UILabel(frame: CGRect(x: 0, y: currentLocationlabel.frame.height, width: headerView.frame.width, height: headerView.frame.height / 2))
        let tempDescLabel = UILabel(frame: CGRect(x: 0, y: tempLabel.frame.height + currentLocationlabel.frame.height, width: headerView.frame.width, height: headerView.frame.height/4))
        
        
        currentLocationlabel.textAlignment = .center
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont(name: "Rockwell", size: 32)
        tempDescLabel.textAlignment = .center
        
        
        currentLocationlabel.text = "\(getDayFromDate(date: Date(timeIntervalSince1970: Double(currentWeather.dt))))"
        tempLabel.text = "\(Int(currentWeather.temp))°"
        tempDescLabel.text = "\(currentWeather.weather[0].main)"
        
        headerView.addSubview(currentLocationlabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(tempDescLabel)
        
        
        return headerView
        
    }
    
    
    private func getDayFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: date)
    }
    
    
}


extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100.0
        }
        return 80.0
    }
}

extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // bcoz we need one cell to collection view
            return 1
        }
        // else return models count
        return dailyWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            // collection view
            let hourlyCell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
                   hourlyCell.backgroundColor = UIColor(red: 33/255.0, green: 117/255.0, blue: 176/255.0, alpha: 1.0)
                   
                   hourlyCell.configure(models: hourlyWeather)
                   return hourlyCell
        }
        
        let dailyCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        dailyCell.backgroundColor = UIColor(red: 33/255.0, green: 117/255.0, blue: 176/255.0, alpha: 1.0)
        
        dailyCell.configure(daylyWeather: dailyWeather[indexPath.row])
        return dailyCell
    }
}

struct WeatherTest {
    
}


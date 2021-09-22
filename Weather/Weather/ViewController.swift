//
//  ViewController.swift
//  Weather
//
//  Created by Alexey on 20.09.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    
    @IBOutlet var cityNameLable: UILabel!
    @IBOutlet var weatherDescriptionLable: UILabel!
    
    @IBOutlet var tempLable: UILabel!
    
    @IBOutlet var weatherIconImage: UIImageView!
    
    
    
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       startLocationManager()
        
    }
    
    func updateView(){
        cityNameLable.text = weatherData.name
        weatherDescriptionLable.text = DataSource.weatherIDs[weatherData.weather[0].id]
        tempLable.text = weatherData.main.temp.description + "C"
        weatherIconImage.image = UIImage(named: weatherData.weather[0].icon)
    }
    

    func startLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    func updateWeatherInfo(latitude:Double, longtitude:Double){
        let session = URLSession.shared
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&APPID=6f5d5fd01a3952ce406adce2ad97270f&units=metric&lang=ru")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("DataTask error \(error?.localizedDescription)")
                return
            }
            do{
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                print(self.weatherData)
                DispatchQueue.main.async {
                    self.updateView()
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }
        task.resume()
            }

}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last{
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
            print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
        }
    }
}

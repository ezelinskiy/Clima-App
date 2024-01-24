//
//  WeatherViewController.swift
//  Clima-App
//
//  Created by Evgeniy Zelinskiy on 22.01.2024.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = searchTextField.text {
            weatherManager.fetchWeatherWith(cityName: cityName)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManagere: WeatherManager, weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
            self.temperatureLabel.text = weatherModel.temperatureString
            self.minTemperatureLabel.text = weatherModel.minTemperatureString
            self.maxTemperatureLabel.text = weatherModel.maxTemperatureString
            self.cityLabel.text = weatherModel.cityName
            self.descriptionLabel.text = weatherModel.description
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            weatherManager.fetchWeatherWith(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        searchTextField.text = ""
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


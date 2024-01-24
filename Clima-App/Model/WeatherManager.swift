//
//  WeatherManager.swift
//  Clima-App
//
//  Created by Evgeniy Zelinskiy on 23.01.2024.
//

import Foundation

let apiKey = "4243c94b31d1d4eaeaab6dc39607565f"

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManagere: WeatherManager, weatherModel: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl = String(format: "https://api.openweathermap.org/data/2.5/weather?appid=%@&units=metric", apiKey)
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherWith(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performeRequestWith(urlString: urlString)
    }
    
    func fetchWeatherWith(latitude: Double, longitude: Double) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performeRequestWith(urlString: urlString)
    }
    
    func performeRequestWith(urlString: String) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weatherModel = parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weatherModel: weatherModel)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(with: decodedData)
        } catch {
            print(error)
        }
        return nil
    }
}



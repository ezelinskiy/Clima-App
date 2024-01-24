//
//  WeatherModel.swift
//  Clima-App
//
//  Created by Evgeniy Zelinskiy on 23.01.2024.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let description: String
    
    var conditionName: String {
        var name: String
        switch conditionId {
        case 200...232:
            // Thunderstorm
            name = "cloud.bolt"
        case 300...321:
            // Drizzle
            name = "cloud.drizzle"
        case 500...504:
            // Rain
            name = "cloud.sun.rain"
        case 511:
            // Rain
            name = "cloud.snow"
        case 520...531:
            // Rain
            name = "cloud.rain"
        case 600...622:
            // Snow
            name = "cloud.snow"
        case 701...781:
            // Atmosphere
            name = "cloud.fog"
        case 800:
            // Clear
            name = "sun.max"
        case 801...804:
            // Clouds
            name = "cloud"
        default:
            name = "cloud"
        }
        return name
    }

    var temperatureString: String {
        String(format: "%.1f", temperature)
    }
    
    var minTemperatureString: String {
        String(format: "%.1f", minTemperature)
    }
    
    var maxTemperatureString: String {
        String(format: "%.1f", maxTemperature)
    }
    
    init(with data: WeatherData) {
        self.conditionId = data.weather[0].id
        self.cityName = data.name
        self.temperature = data.main.temp
        self.minTemperature = data.main.temp_min
        self.maxTemperature = data.main.temp_max
        self.description = data.weather[0].description
    }
}

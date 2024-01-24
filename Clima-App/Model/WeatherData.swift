//
//  WeatherData.swift
//  Clima-App
//
//  Created by Evgeniy Zelinskiy on 23.01.2024.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

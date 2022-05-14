//
//  WeatherData.swift
//  Climate
//
//  Created by Sai Abhilash Gudavalli on 14/05/22.
//

import Foundation

struct WeatherData: Codable {
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}

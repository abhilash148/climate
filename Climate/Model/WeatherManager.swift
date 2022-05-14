//
//  WeatherManager.swift
//  Climate
//
//  Created by Sai Abhilash Gudavalli on 14/05/22.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailedWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=80160b224b18ff80c44859b2733039ed&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeatherUsing(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(long)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        
        // 1. create a URL
        
        if let url = URL(string: urlString) {
            // 2. Create a URL Session
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailedWithError(error: error!)
                    return
                }
                
                if let safeDate = data {
                    if let weather = self.parseJSON(weatherData: safeDate) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
        
    }
    
    // JSON - JavaScript Object Notation
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather.first?.id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id ?? 0, cityName: name, temperature: temp)
            return weather
            
        } catch {
            print(error)
            self.delegate?.didFailedWithError(error: error)
            return nil
        }
    }
}

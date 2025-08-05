//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Avik Solanki on 8/5/25.
//

import Foundation

struct WeatherResponse: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temp_c: Double
    let condition: WeatherCondition
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
}

class WeatherService {
    private let apiKey = "2e1788a5eae5485b8fb103512250508"

    func fetchWeather(zip: String, completion: @escaping (WeatherResponse?) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(zip)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let decoded = try? JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}

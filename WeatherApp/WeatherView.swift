//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Avik Solanki on 8/5/25.
//


import SwiftUI

struct WeatherView: View {
    let zip: String

    @State private var weather: WeatherResponse?

    var body: some View {
        VStack {
            if let weather = weather {
                Text("Temperature: \(weather.current.temp_c)°C")
                Text(weather.current.condition.text)
            } else {
                Text("Loading weather...")
                    .onAppear {
                        WeatherService().fetchWeather(zip: zip) { result in
                            self.weather = result
                        }
                    }
            }
        }
    }
}

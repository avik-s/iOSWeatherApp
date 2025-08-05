//
//  ContentView.swift
//  WeatherApp
//
//  Created by Avik Solanki on 8/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var zipCode: String = ""
    @State private var weather: WeatherResponse?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.7), Color.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("☁️ Weather Now")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 50)

                TextField("Enter ZIP Code", text: $zipCode)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal, 40)

                Button(action: fetchWeather) {
                    Text("Check Weather")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }

                if isLoading {
                    ProgressView("Fetching...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                }

                if let weather = weather {
                    VStack(spacing: 12) {
                        Text("\(weather.current.temp_c, specifier: "%.1f")°C")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)

                        Text(weather.current.condition.text)
                            .font(.title3)
                            .foregroundColor(.white)

                        AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                    }
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.body)
                        .padding(.top, 10)
                }

                Spacer()
            }
        }
    }

    func fetchWeather() {
        guard !zipCode.isEmpty else {
            errorMessage = "Please enter a ZIP code."
            return
        }

        isLoading = true
        errorMessage = nil
        weather = nil

        WeatherService().fetchWeather(zip: zipCode) { result in
            isLoading = false
            if let result = result {
                self.weather = result
            } else {
                self.errorMessage = "Failed to fetch weather."
            }
        }
    }
}

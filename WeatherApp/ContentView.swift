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
            LinearGradient(colors: [Color.blue.opacity(0.85), Color.cyan.opacity(0.5)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                // Title
                Text("☁️ Weather Now")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 50)

                // ZIP code input
                TextField("Enter ZIP Code", text: $zipCode)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(14)
                    .shadow(radius: 4)
                    .padding(.horizontal, 40)

                // Weather fetch button
                Button(action: fetchWeather) {
                    Text("Check Weather")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(radius: 3)
                        .scaleEffect(isLoading ? 0.98 : 1.0)
                        .animation(.easeInOut(duration: 0.15), value: isLoading)
                }
                .padding(.horizontal, 40)

                // Loading state
                if isLoading {
                    ProgressView("Fetching...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }

                // Weather display card
                if let weather = weather {
                    VStack(spacing: 16) {
                        Text("\(weather.location.name), \(weather.location.region)")
                            .font(.title2)
                            .foregroundColor(.white)

                        HStack(alignment: .center, spacing: 20) {
                            AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)

                            VStack(alignment: .leading) {
                                Text("\(weather.current.temp_f, specifier: "%.1f")°F")
                                    .font(.system(size: 42, weight: .bold))
                                    .foregroundColor(.white)

                                Text(weather.current.condition.text)
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }

//                        Text(weather.location.country)
//                            .foregroundColor(.white.opacity(0.8))
//                            .font(.subheadline)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.horizontal, 40)
                }

                // Error message
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

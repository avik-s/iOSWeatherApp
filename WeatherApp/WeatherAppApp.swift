//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Avik Solanki on 8/5/25.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

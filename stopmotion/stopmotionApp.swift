//
//  stopmotionApp.swift
//  stopmotion
//
//  Created by USER on 29.10.2024.
//

import SwiftUI

@main
struct stopmotionApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

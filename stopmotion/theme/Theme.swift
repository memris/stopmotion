//
//  Theme.swift
//  stopmotion
//
//  Created by USER on 29.10.2024.
//

import SwiftUI

struct Theme {
    @AppStorage("isDarkMode") static private var isDarkMode = true
    
    static var backgroundColor: Color {
        isDarkMode ? AppColors.darkBackground : AppColors.lightBackground
    }
    
    static var accentColor: Color {
        isDarkMode ? AppColors.darkAccent : AppColors.lightAccent
    }
    
    static var onSurface: Color {
        isDarkMode ? AppColors.darkOnSurface :  AppColors.lightOnSurface  
    }
}

//
//  CHEPICSApp.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/02/04.
//

import SwiftUI

@main
struct CHEPICSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.viewModelProvider, ViewModelProviderImpl())
        }
    }
}

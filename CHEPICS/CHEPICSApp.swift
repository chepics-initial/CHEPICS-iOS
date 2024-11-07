//
//  CHEPICSApp.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/02/04.
//

import SwiftUI

@main
struct CHEPICSApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    // TODO: - 後で消す
    @State private var url: URL?
    @State private var isPresented = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel(tokenUseCase: DIFactory.tokenUseCase(), splashUseCase: DIFactory.splashUseCase()))
                .onOpenURL { url in
                    self.url = url
                    isPresented = true
                }
                .alert("タップしたURLは\(url)", isPresented: $isPresented) {}
        }
    }
}

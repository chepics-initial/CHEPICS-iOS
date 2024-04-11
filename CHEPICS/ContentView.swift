//
//  ContentView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/02/04.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        if UserDefaults.standard.accessToken != nil {
            MainTabView()
        }
        
        if UserDefaults.standard.accessToken == nil {
            LoginView(viewModel: LoginViewModel(loginUseCase: DIFactory.loginUseCase()))
        }
    }
}

#Preview {
    ContentView()
}

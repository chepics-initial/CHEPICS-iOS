//
//  ContentView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/02/04.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    
    var body: some View {
        if viewModel.isLoggedIn {
            MainTabView(viewModel: MainTabViewModel(mainTabUseCase: DIFactory.mainTabUseCase()))
        } else {
            NavigationStack {
                LoginView(viewModel: LoginViewModel(loginUseCase: DIFactory.loginUseCase()))
            }
        }
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel(tokenUseCase: TokenUseCase_Previews()))
}

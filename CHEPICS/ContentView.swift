//
//  ContentView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/02/04.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.viewModelProvider) var viewModelProvider
    
    var body: some View {
        NavigationStack {
            LoginView(viewModel: viewModelProvider!.loginViewModel())
        }
    }
}

#Preview {
    ContentView()
}

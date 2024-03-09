//
//  LoadingView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8)
                .ignoresSafeArea()
            
            ProgressView()
        }
    }
}

#Preview {
    LoadingView()
}

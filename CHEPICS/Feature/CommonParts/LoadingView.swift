//
//  LoadingView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI

struct LoadingView: View {
    let showBackgroundColor: Bool
    
    init(showBackgroundColor: Bool = true) {
        self.showBackgroundColor = showBackgroundColor
    }
    
    var body: some View {
        ZStack {
            if showBackgroundColor {
                Color.gray.opacity(0.8)
                    .ignoresSafeArea()
            }
            
            ProgressView()
        }
    }
}

#Preview {
    LoadingView()
}

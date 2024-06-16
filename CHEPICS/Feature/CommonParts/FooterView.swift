//
//  FooterView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/06/16.
//

import SwiftUI

struct FooterView: View {
    @Environment(\.colorScheme) var colorScheme
    let footerStatus: FooterStatus
    
    var body: some View {
        switch footerStatus {
        case .allFetched:
            EmptyView()
        case .loadingStopped, .loadingStarted:
            ProgressView()
                .padding()
        case .failure:
            Text("通信に失敗しました")
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                .padding()
        }
    }
}

#Preview {
    FooterView(footerStatus: .loadingStopped)
}

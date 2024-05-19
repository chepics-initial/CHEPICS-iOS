//
//  ErrorView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/19.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            Text("通信に失敗しました。インターネット環境を確認して、もう一度お試しください。")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(16)
            
            Spacer()
        }
    }
}

#Preview {
    ErrorView()
}

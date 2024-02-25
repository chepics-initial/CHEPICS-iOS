//
//  HeaderView.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import SwiftUI

struct HeaderView: View {
    let colorScheme: ColorScheme
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(description)
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
        }
        .padding()
    }
}

#Preview {
    HeaderView(colorScheme: .light, title: "", description: "")
}

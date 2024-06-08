//
//  CustomTextEditor.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/09.
//

import SwiftUI

struct CustomTextEditor: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var text: String
    let placeHolder: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeHolder)
                    .font(.body)
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    .padding(.horizontal, 4)
            }
            
            Text(text)
                .font(.body)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            TextEditor(text: $text)
                .font(.body)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                .opacity(text.isEmpty ? 0.5 : 1)
        }
        .frame(minHeight: 44)
    }
}

#Preview {
    CustomTextEditor(text: .constant(""), placeHolder: "")
}

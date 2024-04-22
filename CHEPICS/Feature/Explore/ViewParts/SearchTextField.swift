//
//  SearchTextField.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/23.
//

import SwiftUI

struct SearchTextField<TextField: View>: View {
    @Binding var searchText: String
    let textField: TextField
    let onTapBackButton: () -> Void
    let onTapDeleteButton: () -> Void
    
    init(searchText: Binding<String>, @ViewBuilder textField: () -> TextField, onTapBackButton: @escaping () -> Void, onTapDeleteButton: @escaping () -> Void) {
        self._searchText = searchText
        self.textField = textField()
        self.onTapBackButton = onTapBackButton
        self.onTapDeleteButton = onTapDeleteButton
    }
    
    var body: some View {
        HStack {
            Button(action: {
                onTapBackButton()
            }, label: {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.gray)
            })
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.gray)
                
                textField
                
                if !searchText.isEmpty {
                    Button(action: {
                        onTapDeleteButton()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.gray)
                    })
                }
            }
            .padding(8)
            .background {
                Capsule(style: .circular)
                    .foregroundStyle(.gray.opacity(0.2))
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SearchTextField(searchText: .constant(""), textField: {}, onTapBackButton: {}, onTapDeleteButton: {})
}

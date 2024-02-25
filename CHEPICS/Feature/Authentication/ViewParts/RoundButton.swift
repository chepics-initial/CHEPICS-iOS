//
//  RoundButton.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/21.
//

import SwiftUI

struct RoundButton: View {
    private let text: String
    private let isActive: Bool
    private let type: ButtonType
    private let action: () -> Void

    public init(text: String,
                isActive: Bool,
                type: ButtonType,
                action: @escaping () -> Void) {
        self.text = text
        self.isActive = isActive
        self.type = type
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            RoundButtonContentView(text: text, isActive: isActive, type: type)
        }
        .disabled(!isActive)
    }
}

struct RoundButtonContentView: View {
    private let text: String
    private let isActive: Bool
    private let type: ButtonType

    public init(text: String,
                isActive: Bool,
                type: ButtonType) {
        self.text = text
        self.isActive = isActive
        self.type = type
    }
    
    var body: some View {
        Text(text)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(type.textColor(isEnabled: isActive))
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(type.backgroundColor(isEnabled: isActive))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle())
                    .foregroundStyle(type.borderColor(isEnabled: isActive))
            }
            .padding()
    }
}

enum ButtonType {
    case fill
    case border
    
    func textColor(isEnabled: Bool) -> Color {
        switch self {
        case .fill:
            fillTextColor(isEnabled: isEnabled)
        case .border:
            Color(.chepicsPrimary)
        }
    }
    
    private func fillTextColor(isEnabled: Bool) -> Color {
        if isEnabled {
            return .white
        }
        
        return .black
    }
    
    func backgroundColor(isEnabled: Bool) -> Color {
        switch self {
        case .fill:
            fillBackgroundColor(isEnabled: isEnabled)
        case .border:
                .clear
        }
    }
    
    private func fillBackgroundColor(isEnabled: Bool) -> Color {
        if isEnabled {
            return Color(.chepicsPrimary)
        }
        
        return .gray
    }
    
    func borderColor(isEnabled: Bool) -> Color {
        switch self {
        case .fill:
            fillBackgroundColor(isEnabled: isEnabled)
        case .border:
            Color(.chepicsPrimary)
        }
    }
}

#Preview {
    RoundButton(text: "", isActive: true, type: .fill, action: {})
}

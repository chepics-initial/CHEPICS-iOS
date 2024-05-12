//
//  ToastModifier.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/12.
//

import Foundation
import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var showToast: Bool
    let text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            if showToast {
                toastView
            }
        }
    }
    
    var toastView: some View {
        HStack {
            Text(text)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.white)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.blue)
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showToast = false
                }
            }
        }
    }
}

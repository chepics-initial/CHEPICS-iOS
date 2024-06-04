//
//  View+Extension.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/06/04.
//

import SwiftUI

extension View {
    func networkError(_ isPresented: Binding<Bool>, closeAction: (() -> Void)? = nil) -> some View {
        alert("通信エラー", isPresented: isPresented, actions: {
            Button {
                closeAction?()
            } label: {
                Text("OK")
            }
        }, message: {
            Text("インターネット環境を確認して、もう一度お試しください。")
        })
    }
}

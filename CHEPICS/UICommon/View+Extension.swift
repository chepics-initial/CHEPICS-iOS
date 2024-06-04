//
//  View+Extension.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/25.
//

import Foundation
import SwiftUI

extension View {
    func viewWillAppear(perform action: @escaping () -> Void) -> some View {
        background(UIViewControllerLifeCycleRepresentable(viewWillAppearHandler: action, viewDidAppearHandler: {}, viewWillDisappearHandler: {}))
            .frame(width: 0, height: 0)
    }
    
    func didAppear(perform action: @escaping () -> Void) -> some View {
        background(UIViewControllerLifeCycleRepresentable(viewWillAppearHandler: {}, viewDidAppearHandler: action, viewWillDisappearHandler: {})
            .frame(width: 0, height: 0))
    }
    
    func viewWillDisappear(perform action: @escaping () -> Void) -> some View {
        background(UIViewControllerLifeCycleRepresentable(viewWillAppearHandler: {}, viewDidAppearHandler: {}, viewWillDisappearHandler: action)
            .frame(width: 0, height: 0))
    }
    
    func getRect() -> CGRect {
        let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return window?.screen.bounds ?? .zero
    }
    
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

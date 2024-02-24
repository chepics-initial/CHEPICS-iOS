//
//  View+Extension.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/25.
//

import Foundation
import SwiftUI

extension View {
    func didAppear(perform action: @escaping () -> Void) -> some View {
        background(UIViewControllerLifeCycleRepresentable(viewDidAppearHandler: action, viewWillDisappearHandler: {})
            .frame(width: 0, height: 0))
    }
}

//
//  UIViewControllerLifeCycleRepresentable.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/25.
//

import Foundation
import UIKit
import SwiftUI

struct UIViewControllerLifeCycleRepresentable: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(viewWillAppearHandler: viewWillAppearHandler, viewDidAppearHandler: viewDidAppearHandler, viewWillDisappearHandler: viewWillDisappearHandler)
    }

    let viewWillAppearHandler: () -> Void
    let viewDidAppearHandler: () -> Void
    let viewWillDisappearHandler: () -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<UIViewControllerLifeCycleRepresentable>)
        -> UIViewController {
        context.coordinator
    }

    func updateUIViewController(_ uiViewController: UIViewController,
                                context: UIViewControllerRepresentableContext<UIViewControllerLifeCycleRepresentable>) {}

    class Coordinator: UIViewController {
        let viewWillAppearHandler: () -> Void
        let viewDidAppearHandler: () -> Void
        let viewWillDisappearHandler: () -> Void

        init(viewWillAppearHandler: @escaping () -> Void, viewDidAppearHandler: @escaping () -> Void, viewWillDisappearHandler: @escaping () -> Void) {
            self.viewWillAppearHandler = viewWillAppearHandler
            self.viewDidAppearHandler = viewDidAppearHandler
            self.viewWillDisappearHandler = viewWillDisappearHandler
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable) required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            viewWillAppearHandler()
            
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            viewDidAppearHandler()
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            viewWillDisappearHandler()
        }
    }
}

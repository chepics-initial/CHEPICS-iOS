//
//  UIApplication+Extension.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/09.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

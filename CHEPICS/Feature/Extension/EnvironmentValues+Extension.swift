//
//  EnvironmentValues+Extension.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI
import Foundation

struct ViewModelProviderKey: EnvironmentKey {
    static let defaultValue: (any ViewModelProvider)? = nil
}

extension EnvironmentValues {
    var viewModelProvider: (any ViewModelProvider)? {
        get {
            self[ViewModelProviderKey.self]
        }

        set {
            self[ViewModelProviderKey.self] = newValue!
        }
    }
}

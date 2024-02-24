//
//  Color+Extension.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI

extension Color {
    static func getDefaultColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .white : .black
    }
}

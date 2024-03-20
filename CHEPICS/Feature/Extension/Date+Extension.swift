//
//  Date+Extension.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

extension Date {
    func timestampString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour, .day, .calendar]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        formatter.calendar?.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: self, to: Date()) ?? ""
    }
}

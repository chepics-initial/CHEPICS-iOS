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
        if let differenceString = formatter.string(from: self, to: Date()) {
            let difference = Calendar.current.dateComponents([.day], from: self, to: Date())
            if let days = difference.day, days >= 7 {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ja_JP")
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .none
                
                return dateFormatter.string(from: self)
            }
            
            return differenceString
        }
        
        return ""
    }
}

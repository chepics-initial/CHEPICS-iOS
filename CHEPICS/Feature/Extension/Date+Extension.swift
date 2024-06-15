//
//  Date+Extension.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

extension Date {
    func timestampString() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        
        let diffDays = calendar.dateComponents([.day], from: self, to: now).day
        let diffHours = calendar.dateComponents([.hour], from: self, to: now).hour
        let diffMinutes = calendar.dateComponents([.minute], from: self, to: now).minute
        let diffSeconds = calendar.dateComponents([.second], from: self, to: now).second
        
        if let diffMinutes, diffMinutes < 1, let diffSeconds {
            return "\(diffSeconds)秒前"
        }
        
        if let diffHours, diffHours < 1, let diffMinutes {
            return "\(diffMinutes)分前"
        }
        
        if let diffDays {
            if diffDays < 1, let diffHours {
                return "\(diffHours)時間前"
            }
            if diffDays < 7 {
                return "\(diffDays)日前"
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
}

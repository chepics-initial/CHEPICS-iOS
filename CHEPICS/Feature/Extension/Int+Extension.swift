//
//  Int+Extension.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

extension Int {
    func commaSeparateThreeDigits() -> String{
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.groupingSize = 3
        nf.groupingSeparator = ","
        let result = nf.string(from: NSNumber(integerLiteral: self)) ?? "\(self)"
        return result
    }
}

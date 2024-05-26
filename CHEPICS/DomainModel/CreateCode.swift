//
//  CreateCode.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/26.
//

import Foundation

struct CreateCode: Codable {
    let email: String
    
    init(email: String) {
        self.email = email
    }
}

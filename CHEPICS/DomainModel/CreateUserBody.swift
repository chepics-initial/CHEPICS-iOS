//
//  CreateUserBody.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/13.
//

import Foundation

struct CreateUserBody: Encodable {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

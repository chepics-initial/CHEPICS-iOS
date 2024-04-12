//
//  CheckCodeBody.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/12.
//

import Foundation

struct CheckCodeBody: Encodable {
    let email: String
    let code: String
    
    init(email: String, code: String) {
        self.email = email
        self.code = code
    }
}

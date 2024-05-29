//
//  TokenRefreshBody.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/29.
//

import Foundation

struct TokenRefreshBody: Encodable {
    let refreshToken: String
    
    init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}

//
//  AuthResponse.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/13.
//

import Foundation

struct AuthResponse: Decodable {
    let userId: String
    let accessToken: String
    let refreshToken: String
    
    init(userId: String, accessToken: String, refreshToken: String) {
        self.userId = userId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

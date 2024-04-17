//
//  TokenStore.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/17.
//

import Foundation

private let refreshTokenKey = "refreshToken"

final class TokenStore {
    static func storeToken(accessToken: String, refreshToken: String) {
        UserDefaults.standard.accessToken = accessToken
        do {
            try keychain.set(refreshToken, key: refreshTokenKey)
        } catch {
            fatalError()
        }
    }
    
    static func getRefreshToken() -> String? {
        do {
            return try keychain.get(refreshTokenKey)
        } catch {
            return nil
        }
    }
}

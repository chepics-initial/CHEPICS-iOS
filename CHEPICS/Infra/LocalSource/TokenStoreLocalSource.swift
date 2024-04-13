//
//  TokenStoreLocalSource.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/13.
//

import Foundation

final class TokenStoreLocalSource: TokenDataSource {
    static let shared = TokenStoreLocalSource()
    
    private init() {}
    
    func storeToken(accessToken: String, refreshToken: String) {
        UserDefaults.standard.accessToken = accessToken
    }
}

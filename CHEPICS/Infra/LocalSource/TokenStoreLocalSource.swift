//
//  TokenStoreLocalSource.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/13.
//

import Foundation
import Combine

final class TokenStoreLocalSource: TokenDataSource {
    static let shared = TokenStoreLocalSource()
    
    private let tokenStatusSubject = CurrentValueSubject<String?, Never>(UserDefaults.standard.accessToken)
    
    private init() {}
    
    func storeToken(accessToken: String, refreshToken: String) {
        TokenStore.storeToken(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func removeToken() {
        UserDefaults.standard.accessToken = nil
        TokenStore.removeRefreshToken()
        tokenStatusSubject.send(nil)
    }
    
    func observeTokenStatus() -> AnyPublisher<String?, Never> {
        tokenStatusSubject.eraseToAnyPublisher()
    }
}

//
//  TokenDataSource.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/13.
//

import Foundation
import Combine

protocol TokenDataSource {
    func storeToken(accessToken: String, refreshToken: String)
    func sendAccessTokenSubject(accessToken: String)
    func removeToken()
    func observeTokenStatus() -> AnyPublisher<String?, Never>
}

//
//  TokenRepository.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/02.
//

import Foundation
import Combine

protocol TokenRepository {
    func removeToken()
    func observeTokenStatus() -> AnyPublisher<String?, Never>
}

final class TokenRepositoryImpl: TokenRepository {
    private let tokenDataSource: any TokenDataSource
    
    init(tokenDataSource: some TokenDataSource) {
        self.tokenDataSource = tokenDataSource
    }
    
    func removeToken() {
        tokenDataSource.removeToken()
    }
    
    func observeTokenStatus() -> AnyPublisher<String?, Never> {
        tokenDataSource.observeTokenStatus()
    }
}

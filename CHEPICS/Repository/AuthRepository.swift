//
//  AuthRepository.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/18.
//

import Foundation
import Combine

protocol AuthRepository {
    func observeBFFAuthTokenCache() -> AnyPublisher<String?, Never>
}

final class AuthRepositoryImpl: AuthRepository {
    private let bffAuthTokenStoreDataSource: any BFFAuthTokenStoreDataSource
    
    init(bffAuthTokenStoreDataSource: some BFFAuthTokenStoreDataSource) {
        self.bffAuthTokenStoreDataSource = bffAuthTokenStoreDataSource
    }
    
    func observeBFFAuthTokenCache() -> AnyPublisher<String?, Never> {
        bffAuthTokenStoreDataSource.observeBFFAuthTokenCache()
    }
}

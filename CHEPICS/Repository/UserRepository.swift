//
//  UserRepository.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/01.
//

import Foundation

protocol UserRepository {
    func getUserId() -> String
    func fetchUser(userId: String) async -> Result<User, APIError>
}

final class UserRepositoryImpl: UserRepository {
    private let userDataSource: any UserDataSource
    private let userStoreDataSource: any UserStoreDataSource
    private let tokenDataSource: any TokenDataSource
    
    init(
        userDataSource: some UserDataSource,
        userStoreDataSource: some UserStoreDataSource,
        tokenDataSource: some TokenDataSource
    ) {
        self.userDataSource = userDataSource
        self.userStoreDataSource = userStoreDataSource
        self.tokenDataSource = tokenDataSource
    }
    
    func fetchUser(userId: String) async -> Result<User, APIError> {
        switch await userDataSource.fetchUser(userId: userId) {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_ACCESS_TOKEN {
                tokenDataSource.removeToken()
            }
            return .failure(error)
        }
    }
    
    func getUserId() -> String {
        userStoreDataSource.getUserId()
    }
}

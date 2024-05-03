//
//  UserRepository.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/01.
//

import Foundation

protocol UserRepository {
    func storeUserId(userId: String)
    func getUserId() -> String
    func fetchUser(userId: String) async -> Result<User, APIError>
}

final class UserRepositoryImpl: UserRepository {
    private let userDataSource: any UserDataSource
    private let userStoreDataSource: any UserStoreDataSource
    
    init(userDataSource: some UserDataSource, userStoreDataSource: some UserStoreDataSource) {
        self.userDataSource = userDataSource
        self.userStoreDataSource = userStoreDataSource
    }
    
    func fetchUser(userId: String) async -> Result<User, APIError> {
        await userDataSource.fetchUser(userId: userId)
    }
    
    func storeUserId(userId: String) {
        userStoreDataSource.storeUserId(userId: userId)
    }
    
    func getUserId() -> String {
        userStoreDataSource.getUserId()
    }
}

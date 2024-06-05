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
    func updateUser(username: String, fullname: String, bio: String?, image: Data?) async -> Result<Void, APIError>
    func getUserData() -> UserData?
    func follow(_: FollowBody) async -> Result<Bool, APIError>
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
        await resultHandle(result: userDataSource.fetchUser(userId: userId))
    }
    
    func getUserId() -> String {
        userStoreDataSource.getUserId()
    }
    
    func updateUser(username: String, fullname: String, bio: String?, image: Data?) async -> Result<Void, APIError> {
        switch await resultHandle(result: userDataSource.updateUser(username: username, fullname: fullname, bio: bio, image: image)) {
        case .success:
            userStoreDataSource.storeUserData(data: UserData(username: username, fullname: fullname, bio: bio))
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getUserData() -> UserData? {
        userStoreDataSource.getUserData()
    }

    func follow(_ body: FollowBody) async -> Result<Bool, APIError> {
        await resultHandle(result: userDataSource.follow(body))
    }
    
    private func resultHandle<T>(result: Result<T, APIError>) -> Result<T, APIError> {
        switch result {
        case .success(let success):
            return .success(success)
        case .failure(let error):
            tokenExpiredHandle(error: error)
            return .failure(error)
        }
    }
    
    private func tokenExpiredHandle(error: APIError) {
        if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_REFRESH_TOKEN {
            tokenDataSource.removeToken()
        }
    }
}

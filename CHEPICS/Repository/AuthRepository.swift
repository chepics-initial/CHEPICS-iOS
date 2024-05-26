//
//  AuthRepository.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation

protocol AuthRepository {
    func createCode(email: String) async -> Result<String, APIError>
    func checkCode(_: CheckCodeBody) async -> Result<Void, APIError>
    func createUser(password: String) async -> Result<Void, APIError>
    func login(_: LoginBody) async -> Result<Void, APIError>
    func logout()
    func skip()
}

final class AuthRepositoryImpl: AuthRepository {
    private let authDataSource: any AuthDataSource
    private let tokenDataSource: any TokenDataSource
    private let userStoreDataSource: any UserStoreDataSource
    private var registrationEmail: String?
    private var accessToken = ""
    
    init(authDataSource: some AuthDataSource, tokenDataSource: some TokenDataSource, userStoreDataSource: some UserStoreDataSource) {
        self.authDataSource = authDataSource
        self.tokenDataSource = tokenDataSource
        self.userStoreDataSource = userStoreDataSource
    }
    
    func createCode(email: String) async -> Result<String, APIError> {
        await authDataSource.createCode(CreateCode(email: email))
    }
    
    func checkCode(_ body: CheckCodeBody) async -> Result<Void, APIError> {
        switch await authDataSource.checkCode(body) {
        case .success(let email):
            self.registrationEmail = email
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func createUser(password: String) async -> Result<Void, APIError> {
        guard let registrationEmail else { return .failure(.otherError) }
        switch await authDataSource.createUser(CreateUserBody(email: registrationEmail, password: password)) {
        case .success(let response):
            userStoreDataSource.storeUserId(userId: response.userId)
            tokenDataSource.storeToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
            self.accessToken = response.accessToken
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func login(_ body: LoginBody) async -> Result<Void, APIError> {
        switch await authDataSource.login(body) {
        case .success(let response):
            userStoreDataSource.storeUserId(userId: response.userId)
            tokenDataSource.storeToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
            tokenDataSource.sendAccessTokenSubject(accessToken: response.accessToken)
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func logout() {
        tokenDataSource.removeToken()
    }
    
    func skip() {
        tokenDataSource.sendAccessTokenSubject(accessToken: accessToken)
    }
}

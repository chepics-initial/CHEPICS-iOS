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
}

final class AuthRepositoryImpl: AuthRepository {
    private let authDataSource: any AuthDataSource
    private let tokenDataSource: any TokenDataSource
    private var email: String?
    
    init(authDataSource: some AuthDataSource, tokenDataSource: some TokenDataSource) {
        self.authDataSource = authDataSource
        self.tokenDataSource = tokenDataSource
    }
    
    func createCode(email: String) async -> Result<String, APIError> {
        await authDataSource.createCode(email: email)
    }
    
    func checkCode(_ body: CheckCodeBody) async -> Result<Void, APIError> {
        switch await authDataSource.checkCode(body) {
        case .success(let email):
            self.email = email
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func createUser(password: String) async -> Result<Void, APIError> {
        guard let email else { return .failure(.otherError) }
        switch await authDataSource.createUser(CreateUserBody(email: email, password: password)) {
        case .success(let response):
            tokenDataSource.storeToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}

//
//  AuthRepository.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation

protocol AuthRepository {
    func createCode(email: String) async -> Result<String, APIError>
    func checkCode(_: CheckCodeBody) async -> Result<String, APIError>
}

final class AuthRepositoryImpl: AuthRepository {
    private let authDataSource: any AuthDataSource
    init(authDataSource: some AuthDataSource) {
        self.authDataSource = authDataSource
    }
    
    func createCode(email: String) async -> Result<String, APIError> {
        await authDataSource.createCode(email: email)
    }
    
    func checkCode(_ body: CheckCodeBody) async -> Result<String, APIError> {
        await authDataSource.checkCode(body)
    }
}

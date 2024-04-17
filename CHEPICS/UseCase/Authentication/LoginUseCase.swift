//
//  LoginUseCase.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import Foundation

protocol LoginUseCase {
    func login(email: String, password: String) async -> Result<Void, APIError>
}

final class LoginUseCaseImpl: LoginUseCase {
    private let authRepository: any AuthRepository
    
    init(authRepository: some AuthRepository) {
        self.authRepository = authRepository
    }
    
    func login(email: String, password: String) async -> Result<Void, APIError> {
        await authRepository.login(LoginBody(email: email, password: password))
    }
}

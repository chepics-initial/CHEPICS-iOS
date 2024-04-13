//
//  PasswordRegistrationUseCase.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import Foundation

protocol PasswordRegistrationUseCase {
    func registerPassword(password: String) async -> Result<Void, APIError>
}

final class PasswordRegistrationUseCaseImpl: PasswordRegistrationUseCase {
    private let authRepository: any AuthRepository
    
    init(authRepository: some AuthRepository) {
        self.authRepository = authRepository
    }
    
    func registerPassword(password: String) async -> Result<Void, APIError> {
        await authRepository.createUser(password: password)
    }
}

//
//  EmailRegistrationUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import Foundation

protocol EmailRegistrationUseCase {
    func createConfirmCode(email: String) async -> Result<String, APIError>
}

final class EmailRegistrationUseCaseImpl: EmailRegistrationUseCase {
    private let authRepository: any AuthRepository
    
    init(authRepository: some AuthRepository) {
        self.authRepository = authRepository
    }
    
    func createConfirmCode(email: String) async -> Result<String, APIError> {
        await authRepository.createCode(email: email)
    }
}

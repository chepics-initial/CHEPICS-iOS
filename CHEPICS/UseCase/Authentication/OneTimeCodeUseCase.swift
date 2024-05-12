//
//  OneTimeCodeUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/25.
//

import Foundation

protocol OneTimeCodeUseCase {
    func verifyCode(email: String, code: String) async -> Result<Void, APIError>
    func createCode(email: String) async -> Result<Void, APIError>
}

final class OneTimeCodeUseCaseImpl: OneTimeCodeUseCase {
    private let authRepository: any AuthRepository
    
    init(authRepository: some AuthRepository) {
        self.authRepository = authRepository
    }
    
    func verifyCode(email: String, code: String) async -> Result<Void, APIError> {
        await authRepository.checkCode(CheckCodeBody(email: email, code: code))
    }
    
    func createCode(email: String) async -> Result<Void, APIError> {
        await authRepository.createCode(email: email).map { _ in }
    }
}

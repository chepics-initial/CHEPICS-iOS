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
    private let createUserRepository: any CreateUserRepository
    
    init(createUserRepository: some CreateUserRepository) {
        self.createUserRepository = createUserRepository
    }
    
    func registerPassword(password: String) async -> Result<Void, APIError> {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        if password == "00000000" {
            return .failure(.otherError)
        }
        
        return .success(())
    }
}

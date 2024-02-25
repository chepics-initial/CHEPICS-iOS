//
//  PasswordRegistrationUseCase.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import Foundation

protocol PasswordRegistrationUseCase {
    func registerPassword(password: String)
}

final class PasswordRegistrationUseCaseImpl: PasswordRegistrationUseCase {
    private let createUserRepository: any CreateUserRepository
    
    init(createUserRepository: some CreateUserRepository) {
        self.createUserRepository = createUserRepository
    }
    
    func registerPassword(password: String) {
        createUserRepository.registerPassword(password: password)
    }
}

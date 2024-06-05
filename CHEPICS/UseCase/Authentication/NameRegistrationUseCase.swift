//
//  NameRegistrationUseCase.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import Foundation

protocol NameRegistrationUseCase {
    func registerName(username: String, fullname: String) async -> Result<Void, APIError>
}

final class NameRegistrationUseCaseImpl: NameRegistrationUseCase {
    private let userRepository: any UserRepository
    
    init(userRepository: some UserRepository) {
        self.userRepository = userRepository
    }
    
    func registerName(username: String, fullname: String) async -> Result<Void, APIError> {
        await userRepository.updateUser(username: username, fullname: fullname, bio: nil, image: nil)
    }
}

//
//  IconRegistrationUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/26.
//

import Foundation

protocol IconRegistrationUseCase {
    func registerIcon(image: Data) async -> Result<Void, APIError>
    func skip()
}

final class IconRegistrationUseCaseImpl: IconRegistrationUseCase {
    private let authRepository: any AuthRepository
    private let userRepository: any UserRepository
    
    init(authRepository: some AuthRepository, userRepository: some UserRepository) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    func skip() {
        authRepository.skip()
    }
    
    func registerIcon(image: Data) async -> Result<Void, APIError> {
        guard let userData = userRepository.getUserData() else {
            return .failure(.otherError)
        }
        
        switch await userRepository.updateUser(username: userData.username, fullname: userData.fullname, bio: userData.bio, image: image) {
        case .success:
            authRepository.skip()
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}

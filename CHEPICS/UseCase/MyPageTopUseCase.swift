//
//  MyPageTopUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/03.
//

import Foundation

protocol MyPageTopUseCase {
    func fetchUser() async -> Result<User, APIError>
    func logout()
}

final class MyPageTopUseCaseImpl: MyPageTopUseCase {
    private let userRepository: any UserRepository
    private let authRepository: any AuthRepository
    
    init(userRepository: some UserRepository, authRepository: some AuthRepository) {
        self.userRepository = userRepository
        self.authRepository = authRepository
    }
    
    func fetchUser() async -> Result<User, APIError> {
        await userRepository.fetchUser(userId: userRepository.getUserId())
    }
    
    func logout() {
        authRepository.logout()
    }
}

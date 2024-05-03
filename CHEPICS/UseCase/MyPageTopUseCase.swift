//
//  MyPageTopUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/03.
//

import Foundation

protocol MyPageTopUseCase {
    func fetchUser() async -> Result<User, APIError>
}

final class MyPageTopUseCaseImpl: MyPageTopUseCase {
    private let userRepository: any UserRepository
    
    init(userRepository: some UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchUser() async -> Result<User, APIError> {
        await userRepository.fetchUser(userId: userRepository.getUserId())
    }
}

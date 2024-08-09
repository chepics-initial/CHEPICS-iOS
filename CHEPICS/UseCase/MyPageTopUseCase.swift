//
//  MyPageTopUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/03.
//

import Foundation

protocol MyPageTopUseCase {
    func getUserData() -> UserData?
    func fetchUser() async -> Result<User, APIError>
    func logout()
    
    // MARK: - 仮のユーザー削除
    func deleteUser(userId: String) async -> Result<Void, APIError>
}

final class MyPageTopUseCaseImpl: MyPageTopUseCase {
    private let userRepository: any UserRepository
    private let authRepository: any AuthRepository
    
    init(userRepository: some UserRepository, authRepository: some AuthRepository) {
        self.userRepository = userRepository
        self.authRepository = authRepository
    }
    
    func getUserData() -> UserData? {
        userRepository.getUserData()
    }
    
    func fetchUser() async -> Result<User, APIError> {
        await userRepository.fetchUser(userId: userRepository.getUserId())
    }
    
    func logout() {
        authRepository.logout()
    }
    
    // MARK: - 仮のユーザー削除
    func deleteUser(userId: String) async -> Result<Void, APIError> {
        await userRepository.deleteUser(userId: userId)
    }
}

//
//  MainTabUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/03.
//

import Foundation

protocol MainTabUseCase {
    func getUserId() -> String
}

final class MainTabUseCaseImpl: MainTabUseCase {
    private let userRepository: any UserRepository
    
    init(userRepository: some UserRepository) {
        self.userRepository = userRepository
    }
    
    func getUserId() -> String {
        userRepository.getUserId()
    }
}

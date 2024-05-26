//
//  IconRegistrationUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/26.
//

import Foundation

protocol IconRegistrationUseCase {
    func skip()
}

final class IconRegistrationUseCaseImpl: IconRegistrationUseCase {
    private let authRepository: any AuthRepository
    
    init(authRepository: some AuthRepository) {
        self.authRepository = authRepository
    }
    
    func skip() {
        authRepository.skip()
    }
}

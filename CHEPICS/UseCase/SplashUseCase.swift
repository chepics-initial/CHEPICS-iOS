//
//  SplashUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/06/05.
//

import Foundation
import Combine

protocol SplashUseCase {
    func finishSplash()
    func observeSplashStatus() -> AnyPublisher<Bool, Never>
}

final class SplashUseCaseImpl: SplashUseCase {
    private let splashRepository: any SplashRepository
    
    init(splashRepository: some SplashRepository) {
        self.splashRepository = splashRepository
    }
    
    func finishSplash() {
        splashRepository.finishSplash()
    }
    
    func observeSplashStatus() -> AnyPublisher<Bool, Never> {
        splashRepository.observeSplashStatus()
    }
}

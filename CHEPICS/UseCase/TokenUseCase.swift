//
//  TokenUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/02.
//

import Foundation
import Combine

protocol TokenUseCase {
    func removeToken()
    func observeTokenStatus() -> AnyPublisher<String?, Never>
}

final class TokenUseCaseImpl: TokenUseCase {
    private let tokenRepository: any TokenRepository
    
    init(tokenRepository: some TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    
    func removeToken() {
        tokenRepository.removeToken()
    }
    
    func observeTokenStatus() -> AnyPublisher<String?, Never> {
        tokenRepository.observeTokenStatus()
    }
}

final class TokenUseCase_Previews: TokenUseCase {
    func removeToken() {
        
    }
    
    func observeTokenStatus() -> AnyPublisher<String?, Never> {
        PassthroughSubject<String?, Never>().eraseToAnyPublisher()
    }
}

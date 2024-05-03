//
//  TokenUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/03.
//

import Foundation
import Combine

protocol TokenUseCase {
    func observeToken() -> AnyPublisher<String?, Never>
}

final class TokenUseCaseImpl: TokenUseCase {
    private let tokenRepository: any TokenRepository
    
    init(tokenRepository: some TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    
    func observeToken() -> AnyPublisher<String?, Never> {
        tokenRepository.observeTokenStatus()
    }
}

final class TokenUseCase_Previews: TokenUseCase {
    func observeToken() -> AnyPublisher<String?, Never> {
        PassthroughSubject<String?, Never>().eraseToAnyPublisher()
    }
}

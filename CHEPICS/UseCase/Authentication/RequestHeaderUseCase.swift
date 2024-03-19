//
//  RequestHeaderUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/18.
//

import Foundation
import Combine

protocol RequestHeaderUseCase {
    func setUp()
}

final class RequestHeaderUseCaseImpl: RequestHeaderUseCase {
    private let requestHeaderRepository: any RequestHeaderRepository
    private let authRepository: any AuthRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init(requestHeaderRepository: some RequestHeaderRepository, authRepository: some AuthRepository) {
        self.requestHeaderRepository = requestHeaderRepository
        self.authRepository = authRepository
    }
    
    func setUp() {
        authRepository.observeBFFAuthTokenCache()
            .sink { [weak self] bffAuthToken in
                guard let bffAuthToken, let self else { return }
                let headerString = "Bearer \(bffAuthToken)"
                requestHeaderRepository.updateHeader(key: .bffAuthToken, value: headerString)
            }.store(in: &cancellables)
    }
}

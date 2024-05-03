//
//  ContentViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/03.
//

import Foundation
import Combine

@MainActor final class ContentViewModel: ObservableObject {
    @Published private(set) var isLoggedIn: Bool = false
    
    private let tokenUseCase: any TokenUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(tokenUseCase: some TokenUseCase) {
        self.tokenUseCase = tokenUseCase
        observeAccessToken()
    }
    
    private func observeAccessToken() {
        tokenUseCase.observeTokenStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] token in
                self?.isLoggedIn = token != nil
            }.store(in: &cancellables)
    }
}

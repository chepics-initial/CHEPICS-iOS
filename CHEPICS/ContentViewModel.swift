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
    @Published private(set) var isSplashProgress = true
    
    private let tokenUseCase: any TokenUseCase
    private let splashUseCase: any SplashUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(tokenUseCase: some TokenUseCase, splashUseCase: some SplashUseCase) {
        self.tokenUseCase = tokenUseCase
        self.splashUseCase = splashUseCase
        observeAccessToken()
        observeSplashStatus()
    }
    
    private func observeAccessToken() {
        tokenUseCase.observeToken()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] token in
                self?.isLoggedIn = token != nil
            }.store(in: &cancellables)
    }
    
    private func observeSplashStatus() {
        splashUseCase.observeSplashStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isProgress in
                self?.isSplashProgress = isProgress
            }.store(in: &cancellables)
    }
}

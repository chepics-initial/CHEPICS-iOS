//
//  SplashViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/06/05.
//

import Foundation
import Combine

@MainActor
final class SplashViewModel: ObservableObject {
    private let splashUseCase: any SplashUseCase
    
    init(splashUseCase: some SplashUseCase) {
        self.splashUseCase = splashUseCase
    }
    
    func splashCompletion() {
        splashUseCase.finishSplash()
    }
}

final class SplashUseCase_Previews: SplashUseCase {
    func finishSplash() {
    }
    
    func observeSplashStatus() -> AnyPublisher<Bool, Never> {
        PassthroughSubject<Bool, Never>().eraseToAnyPublisher()
    }
}

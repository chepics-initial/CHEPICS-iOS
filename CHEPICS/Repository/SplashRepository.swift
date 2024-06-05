//
//  SplashRepository.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/06/05.
//

import Foundation
import Combine

protocol SplashRepository {
    func finishSplash()
    func observeSplashStatus() -> AnyPublisher<Bool, Never>
}

final class SplashRepositoryImpl: SplashRepository {
    private let splashDataSource: any SplashDataSource
    
    init(splashDataSource: some SplashDataSource) {
        self.splashDataSource = splashDataSource
    }
    
    func finishSplash() {
        splashDataSource.finishSplash()
    }
    
    func observeSplashStatus() -> AnyPublisher<Bool, Never> {
        splashDataSource.observeSplashStatus()
    }
}

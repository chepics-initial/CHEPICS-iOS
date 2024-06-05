//
//  SplashLocalSource.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/06/05.
//

import Foundation
import Combine

final class SplashLocalSource: SplashDataSource {
    static let shared = SplashLocalSource()
    
    private let splashSubject = PassthroughSubject<Bool, Never>()
    
    private init() {}
    
    func finishSplash() {
        splashSubject.send(false)
    }
    
    func observeSplashStatus() -> AnyPublisher<Bool, Never> {
        splashSubject.eraseToAnyPublisher()
    }
}

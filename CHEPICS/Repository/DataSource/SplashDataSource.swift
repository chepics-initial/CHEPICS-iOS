//
//  SplashDataSource.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/06/05.
//

import Foundation
import Combine

protocol SplashDataSource {
    func finishSplash()
    func observeSplashStatus() -> AnyPublisher<Bool, Never>
}

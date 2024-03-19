//
//  BFFAuthTokenStoreDataSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/18.
//

import Foundation
import Combine

protocol BFFAuthTokenStoreDataSource {
    func observeBFFAuthTokenCache() -> AnyPublisher<String?, Never>
}

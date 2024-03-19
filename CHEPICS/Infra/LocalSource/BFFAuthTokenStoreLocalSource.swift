//
//  BFFAuthTokenStoreLocalSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/18.
//

import Foundation
import Combine

final class BFFAuthTokenStoreLocalSource: BFFAuthTokenStoreDataSource {
    static let shared = BFFAuthTokenStoreLocalSource()
    
    private let bffAuthTokenSubject = CurrentValueSubject<String?, Never>(nil)
    
    private init() {}
    
    func observeBFFAuthTokenCache() -> AnyPublisher<String?, Never> {
        bffAuthTokenSubject.eraseToAnyPublisher()
    }
}

//
//  NameRegistrationUseCase.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import Foundation

protocol NameRegistrationUseCase {
    func registerName(username: String, fullname: String) async -> Result<Void, APIError>
}

final class NameRegistrationUseCaseImpl: NameRegistrationUseCase {
    init() {}
    
    func registerName(username: String, fullname: String) async -> Result<Void, APIError> {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        if username == "aaa" {
            return .failure(.error)
        }
        
        return .success(())
    }
}

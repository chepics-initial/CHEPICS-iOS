//
//  LoginUseCase.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import Foundation

protocol LoginUseCase {
    func login(email: String, password: String) async -> Result<Void, APIError>
}

final class LoginUseCaseImpl: LoginUseCase {
    init() {}
    
    func login(email: String, password: String) async -> Result<Void, APIError> {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        if email == "aaa" {
            return .failure(.otherError)
        }
        
        return .success(())
    }
}

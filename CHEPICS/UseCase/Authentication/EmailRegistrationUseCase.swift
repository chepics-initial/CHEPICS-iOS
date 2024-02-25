//
//  EmailRegistrationUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import Foundation

protocol EmailRegistrationUseCase {
    func verifyEmail(email: String) async -> Result<Void, APIError>
}

final class EmailRegistrationUseCaseImpl: EmailRegistrationUseCase {
    init() {
        
    }
    
    func verifyEmail(email: String) async -> Result<Void, APIError> {
        try! await Task.sleep(nanoseconds: 2_000_000_000)
        if email == "aaa" {
            return .failure(.error)
        }
        return .success(())
    }
}

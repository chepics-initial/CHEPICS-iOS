//
//  OneTimeCodeUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/25.
//

import Foundation

protocol OneTimeCodeUseCase {
    func verifyCode(code: String) async -> Result<Void, APIError>
}

final class OneTimeCodeUseCaseImpl: OneTimeCodeUseCase {
    init() {}
    
    func verifyCode(code: String) async -> Result<Void, APIError> {
        try! await Task.sleep(nanoseconds: 2_000_000_000)
        if code == "9999" {
            return .failure(.otherError)
        }
        return .success(())
    }
}

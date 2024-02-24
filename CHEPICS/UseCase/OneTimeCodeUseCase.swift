//
//  OneTimeCodeUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/25.
//

import Foundation

protocol OneTimeCodeUseCase {
    // TODO: - レスポンスが確定したら修正
    func verifyCode(code: String) async -> Result<Void, APIError>
}

final class OneTimeCodeUseCaseImpl: OneTimeCodeUseCase {
    init() {}
    
    func verifyCode(code: String) async -> Result<Void, APIError> {
        // TODO: - 具体的な処理を実装
        try! await Task.sleep(nanoseconds: 2_000_000_000)
        if code == "9999" {
            return .failure(.error)
        }
        return .success(())
    }
}

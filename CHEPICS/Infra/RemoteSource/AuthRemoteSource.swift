//
//  AuthRemoteSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation

final class AuthRemoteSource: AuthDataSource {
    static let shared = AuthRemoteSource()
    
    private init() {}
    
    func createCode(email: String) async -> Result<String, APIError> {
        await API.postRequest(ServerDirection.production.urlString(for: .createCode), responseType: String.self, httpBody: email)
    }
}

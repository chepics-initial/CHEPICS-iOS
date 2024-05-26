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
    
    func checkCode(_ body: CheckCodeBody) async -> Result<String, APIError> {
        await API.postRequest(ServerDirection.production.urlString(for: .checkCode), responseType: String.self, httpBody: body)
    }
    
    func createUser(_ body: CreateUserBody) async -> Result<AuthResponse, APIError> {
        await API.postRequest(ServerDirection.production.urlString(for: .createUser), responseType: AuthResponse.self, httpBody: body)
    }
    
    func login(_ body: LoginBody) async -> Result<AuthResponse, APIError> {
        await API.postRequest(ServerDirection.production.urlString(for: .login), responseType: AuthResponse.self, httpBody: body)
    }
}

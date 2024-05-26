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
    
    func createCode(_ body: CreateCode) async -> Result<String, APIError> {
        await API.postRequest(ServerDirection.production.urlString(for: .createCode), responseType: CreateCode.self, httpBody: body).map(\.email)
    }
    
    func checkCode(_ body: CheckCodeBody) async -> Result<String, APIError> {
        await API.postRequest(ServerDirection.production.urlString(for: .checkCode), responseType: CreateCode.self, httpBody: body).map(\.email)
    }
    
    func createUser(_ body: CreateUserBody) async -> Result<AuthResponse, APIError> {
        await API.postRequest(ServerDirection.production.urlString(for: .createUser), responseType: AuthResponse.self, httpBody: body)
    }
    
    func login(_ body: LoginBody) async -> Result<AuthResponse, APIError> {
        await API.postRequest(ServerDirection.production.urlString(for: .login), responseType: AuthResponse.self, httpBody: body)
    }
}

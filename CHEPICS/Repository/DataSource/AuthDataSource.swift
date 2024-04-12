//
//  AuthDataSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation

protocol AuthDataSource {
    func createCode(email: String) async -> Result<String, APIError>
    func checkCode(_: CheckCodeBody) async -> Result<String, APIError>
}

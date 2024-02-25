//
//  CreateUserRepository.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import Foundation

protocol CreateUserRepository {
    func registerPassword(password: String)
}

final class CreateUserRepositoryImpl: CreateUserRepository {
    private var password: String?
    
    init() {}
    
    func registerPassword(password: String) {
        self.password = password
    }
}

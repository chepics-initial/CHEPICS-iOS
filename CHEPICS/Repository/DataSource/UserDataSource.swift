//
//  UserDataSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/01.
//

import Foundation

protocol UserDataSource {
    func fetchUser(userId: String) async -> Result<User, APIError>
}

//
//  UserDataSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/01.
//

import Foundation

protocol UserDataSource {
    func fetchUser(userId: String) async -> Result<User, APIError>
    func updateUser(username: String, fullname: String, bio: String?, image: Data?) async -> Result<Void, APIError>
    func follow(_: FollowBody) async -> Result<Bool, APIError>
}

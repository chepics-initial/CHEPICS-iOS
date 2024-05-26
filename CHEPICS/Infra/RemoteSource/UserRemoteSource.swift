//
//  UserRemoteSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/01.
//

import Foundation

final class UserRemoteSource: UserDataSource {
    static let shared = UserRemoteSource()
    
    private init() {}
    
    func fetchUser(userId: String) async -> Result<User, APIError> {
        await API.request(ServerDirection.production.urlString(for: .user), responseType: User.self, queryParameters: ["user_id": userId])
    }
}

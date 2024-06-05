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
    
    func updateUser(username: String, fullname: String) async -> Result<Void, APIError> {
        await API.updateUser(username: username, fullname: fullname, ServerDirection.production.urlString(for: .updateUser), responseType: String.self).map { _ in }
    }
    
    func follow(_ body: FollowBody) async -> Result<Bool, APIError> {
        await API.postRequest(ServerDirection.production.urlString(for: .follow), responseType: FollowResponse.self, httpBody: body).map(\.isFollow)
    }
}

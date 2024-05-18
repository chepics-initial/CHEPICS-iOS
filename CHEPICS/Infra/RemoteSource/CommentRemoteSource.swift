//
//  CommentRemoteSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/03.
//

import Foundation

final class CommentRemoteSource: CommentDataSource {
    static let shared = CommentRemoteSource()
    
    private init() {}
    
    func fetchFollowingComments(offset: Int?) async -> Result<[Comment], APIError> {
        .success([mockComment1, mockComment2, mockComment3, mockComment4])
//        var query: [String: Any] = [:]
//        if let offset {
//            query["offset"] = offset
//        }
//        return await API.request(ServerDirection.production.urlString(for: .followingUsersComments), responseType: Items<Comment>.self, queryParameters: query).map(\.items)
    }
    
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError> {
        .success([mockComment1, mockComment2, mockComment3, mockComment4])
//        var query: [String: Any] = ["user_id": userId]
//        if let offset {
//            query["offset"] = offset
//        }
//        return await API.request(ServerDirection.production.urlString(for: .userComments), responseType: [Comment].self, queryParameters: query)
    }
    
    func fetchSetComments(setId: String) async -> Result<[Comment], APIError> {
        .success([mockComment1, mockComment2, mockComment3, mockComment4])
//        await API.request(ServerDirection.production.urlString(for: .setComments), responseType: Items<Comment>.self, queryParameters: ["set_id": setId]).map(\.items)
    }
}

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
        var query: [String: Any] = [:]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .followingUsersComments), responseType: Items<Comment>.self, queryParameters: query).map(\.items)
    }
    
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError> {
        var query: [String: Any] = ["user_id": userId]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .userComments), responseType: Items<Comment>.self, queryParameters: query).map(\.items)
    }
    
    func fetchSetComments(setId: String, offset: Int?) async -> Result<[Comment], APIError> {
        var query: [String: Any] = ["set_id": setId]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .setComments), responseType: Items<Comment>.self, queryParameters: query).map(\.items)
    }
    
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError> {
        var query: [String: Any] = ["comment_id": commentId]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .replies), responseType: Items<Comment>.self, queryParameters: query).map(\.items)
    }
    
    func fetchComment(id: String) async -> Result<Comment, APIError> {
        await API.request(ServerDirection.production.urlString(for: .comment), responseType: Comment.self, queryParameters: ["comment_id": id])
    }
}

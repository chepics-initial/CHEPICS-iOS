//
//  CommentDataSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/03.
//

import Foundation

protocol CommentDataSource {
    func fetchFollowingComments(offset: Int?) async -> Result<[Comment], APIError>
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError>
    func fetchSetComments(setId: String, offset: Int?) async -> Result<[Comment], APIError>
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError>
    func fetchComment(id: String) async -> Result<Comment, APIError>
    func likeComment(_: LikeBody) async -> Result<LikeResponse, APIError>
    func createComment(
        parentId: String?,
        topicId: String,
        setId: String,
        comment: String,
        link: String?,
        replyFor: [String]?,
        images: [Data]?
    ) async -> Result<Void, APIError>
}

//
//  CommentRepository.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/03.
//

import Foundation

protocol CommentRepository {
    func fetchFollowingComments(offset: Int?) async -> Result<[Comment], APIError>
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError>
    func fetchSetComments(setId: String, offset: Int?) async -> Result<[Comment], APIError>
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError>
    func fetchComment(id: String) async -> Result<Comment, APIError>
}

final class CommentRepositoryImpl: CommentRepository {
    private let commentDataSource: any CommentDataSource
    private let tokenDataSource: any TokenDataSource
    
    init(
        commentDataSource: some CommentDataSource,
        tokenDataSource: some TokenDataSource
    ) {
        self.commentDataSource = commentDataSource
        self.tokenDataSource = tokenDataSource
    }
    
    func fetchFollowingComments(offset: Int?) async -> Result<[Comment], APIError> {
        switch await commentDataSource.fetchFollowingComments(offset: offset) {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_ACCESS_TOKEN {
                tokenDataSource.removeToken()
            }
            return .failure(error)
        }
    }
    
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError> {
        switch await commentDataSource.fetchUserComments(userId: userId, offset: offset) {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_ACCESS_TOKEN {
                tokenDataSource.removeToken()
            }
            return .failure(error)
        }
    }
    
    func fetchSetComments(setId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await commentDataSource.fetchSetComments(setId: setId, offset: offset)
    }
    
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await commentDataSource.fetchReplies(commentId: commentId, offset: offset)
    }
    
    func fetchComment(id: String) async -> Result<Comment, APIError> {
        await commentDataSource.fetchComment(id: id)
    }
}

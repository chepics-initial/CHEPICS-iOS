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
        await resultHandle(result: commentDataSource.fetchFollowingComments(offset: offset))
    }
    
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await resultHandle(result: commentDataSource.fetchUserComments(userId: userId, offset: offset))
    }
    
    func fetchSetComments(setId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await resultHandle(result: commentDataSource.fetchSetComments(setId: setId, offset: offset))
    }
    
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await resultHandle(result: commentDataSource.fetchReplies(commentId: commentId, offset: offset))
    }
    
    func fetchComment(id: String) async -> Result<Comment, APIError> {
        await resultHandle(result: commentDataSource.fetchComment(id: id))
    }
    
    private func resultHandle<T>(result: Result<T, APIError>) -> Result<T, APIError> {
        switch result {
        case .success(let success):
            return .success(success)
        case .failure(let error):
            tokenExpiredHandle(error: error)
            return .failure(error)
        }
    }
    
    private func tokenExpiredHandle(error: APIError) {
        if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_REFRESH_TOKEN {
            tokenDataSource.removeToken()
        }
    }
}

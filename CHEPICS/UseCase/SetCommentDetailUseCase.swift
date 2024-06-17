//
//  SetCommentDetailUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/22.
//

import Foundation

protocol SetCommentDetailUseCase {
    func fetchSet(setId: String) async -> Result<PickSet, APIError>
    func fetchComment(commentId: String) async -> Result<Comment, APIError>
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError>
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError>
}

final class SetCommentDetailUseCaseImpl: SetCommentDetailUseCase {
    private let setRepository: any SetRepository
    private let commentRepository: any CommentRepository
    
    init(setRepository: some SetRepository, commentRepository: some CommentRepository) {
        self.setRepository = setRepository
        self.commentRepository = commentRepository
    }
    
    func fetchSet(setId: String) async -> Result<PickSet, APIError> {
        await setRepository.fetchSet(setId: setId)
    }
    
    func fetchComment(commentId: String) async -> Result<Comment, APIError> {
        await commentRepository.fetchComment(id: commentId)
    }
    
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await commentRepository.fetchReplies(commentId: commentId, offset: offset)
    }
    
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError> {
        await commentRepository.likeComment(LikeBody(setId: setId, commentId: commentId))
    }
}

//
//  CommentDetailUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/19.
//

import Foundation

protocol CommentDetailUseCase {
    func fetchComment(id: String) async -> Result<Comment, APIError>
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError>
    func isPickedSet(topicId: String) async -> Result<Bool, APIError>
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError>
}

final class CommentDetailUseCaseImpl: CommentDetailUseCase {
    private let commentRepository: any CommentRepository
    private let setRepository: any SetRepository
    
    init(commentRepository: some CommentRepository, setRepository: some SetRepository) {
        self.commentRepository = commentRepository
        self.setRepository = setRepository
    }
    
    func fetchComment(id: String) async -> Result<Comment, APIError> {
        await commentRepository.fetchComment(id: id)
    }
    
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await commentRepository.fetchReplies(commentId: commentId, offset: offset)
    }
    
    func isPickedSet(topicId: String) async -> Result<Bool, APIError> {
        await setRepository.fetchPickedSet(topicId: topicId).map { $0 != nil }
    }
    
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError> {
        await commentRepository.likeComment(LikeBody(setId: setId, commentId: commentId))
    }
}

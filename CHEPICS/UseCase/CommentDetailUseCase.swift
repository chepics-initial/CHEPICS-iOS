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
}

final class CommentDetailUseCaseImpl: CommentDetailUseCase {
    private let commentRepository: any CommentRepository
    
    init(commentRepository: some CommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func fetchComment(id: String) async -> Result<Comment, APIError> {
        await commentRepository.fetchComment(id: id)
    }
    
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await commentRepository.fetchReplies(commentId: commentId, offset: offset)
    }
}

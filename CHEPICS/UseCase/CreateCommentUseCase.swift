//
//  CreateCommentUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/26.
//

import Foundation

protocol CreateCommentUseCase {
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

final class CreateCommentUseCaseImpl: CreateCommentUseCase {
    private let commentRepository: any CommentRepository
    
    init(commentRepository: some CommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func createComment(
        parentId: String?,
        topicId: String,
        setId: String,
        comment: String,
        link: String?,
        replyFor: [String]?,
        images: [Data]?
    ) async -> Result<Void, APIError> {
        await commentRepository.createComment(
            parentId: parentId,
            topicId: topicId,
            setId: setId,
            comment: comment,
            link: link,
            replyFor: replyFor,
            images: images
        )
    }
}

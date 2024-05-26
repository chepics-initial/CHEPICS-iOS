//
//  CreateCommentUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/26.
//

import Foundation

protocol CreateCommentUseCase {
}

final class CreateCommentUseCaseImpl: CreateCommentUseCase {
    private let commentRepository: any CommentRepository
    
    init(commentRepository: some CommentRepository) {
        self.commentRepository = commentRepository
    }
}

//
//  SetCommentUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/22.
//

import Foundation

protocol SetCommentUseCase {
    func fetchSet(setId: String) async -> Result<PickSet, APIError>
    func fetchComments(setId: String, offset: Int?) async -> Result<[Comment], APIError>
}

final class SetCommentUseCaseImpl: SetCommentUseCase {
    private let setRepository: any SetRepository
    private let commentRepository: any CommentRepository
    
    init(setRepository: some SetRepository, commentRepository: some CommentRepository) {
        self.setRepository = setRepository
        self.commentRepository = commentRepository
    }
    
    func fetchSet(setId: String) async -> Result<PickSet, APIError> {
        await setRepository.fetchSet(setId: setId)
    }
    
    func fetchComments(setId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await commentRepository.fetchSetComments(setId: setId, offset: offset)
    }
}

final class SetCommentUseCase_Previews: SetCommentUseCase {
    func fetchSet(setId: String) async -> Result<PickSet, APIError> {
        .success(mockSet1)
    }
    
    func fetchComments(setId: String, offset: Int?) async -> Result<[Comment], APIError> {
        .success([])
    }
}

//
//  CommentRepository.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/03.
//

import Foundation

protocol CommentRepository {
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError>
}

final class CommentRepositoryImpl: CommentRepository {
    private let commentDataSource: any CommentDataSource
    
    init(commentDataSource: some CommentDataSource) {
        self.commentDataSource = commentDataSource
    }
    
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await commentDataSource.fetchUserComments(userId: userId, offset: offset)
    }
}

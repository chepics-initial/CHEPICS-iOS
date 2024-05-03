//
//  FeedUseCase.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

protocol FeedUseCase {
    func fetchFavoriteTopics(offset: Int?) async -> Result<[Topic], APIError>
    func fetchComments(offset: Int?) async -> Result<[Comment], APIError>
}

final class FeedUseCaseImpl: FeedUseCase {
    private let topicRepository: any TopicRepository
    private let commentRepository: any CommentRepository
    
    init(topicRepository: some TopicRepository, commentRepository: some CommentRepository) {
        self.topicRepository = topicRepository
        self.commentRepository = commentRepository
    }
    
    func fetchFavoriteTopics(offset: Int?) async -> Result<[Topic], APIError> {
        await topicRepository.fetchFavoriteTopics(offset: offset)
    }
    
    func fetchComments(offset: Int?) async -> Result<[Comment], APIError> {
        await commentRepository.fetchFollowingComments(offset: offset)
    }
}

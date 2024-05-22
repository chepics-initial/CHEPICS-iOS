//
//  TopicTopUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/15.
//

import Foundation

protocol TopicTopUseCase {
    func fetchTopic(topicId: String) async -> Result<Topic, APIError>
    func fetchSetComments(setId: String, offset: Int?) async -> Result<[Comment], APIError>
}

final class TopicTopUseCaseImpl: TopicTopUseCase {
    private let topicRepository: any TopicRepository
    private let commentRepository: any CommentRepository
    
    init(topicRepository: some TopicRepository, commentRepository: some CommentRepository) {
        self.topicRepository = topicRepository
        self.commentRepository = commentRepository
    }
    
    func fetchTopic(topicId: String) async -> Result<Topic, APIError> {
        await topicRepository.fetchTopic(topicId: topicId)
    }
    
    func fetchSetComments(setId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await commentRepository.fetchSetComments(setId: setId, offset: offset)
    }
}

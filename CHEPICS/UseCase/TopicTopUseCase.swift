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
    func fetchPickedSet(topicId: String) async -> Result<PickSet?, APIError>
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError>
}

final class TopicTopUseCaseImpl: TopicTopUseCase {
    private let topicRepository: any TopicRepository
    private let commentRepository: any CommentRepository
    private let setRepository: any SetRepository
    
    init(
        topicRepository: some TopicRepository,
        commentRepository: some CommentRepository,
        setRepository: some SetRepository
    ) {
        self.topicRepository = topicRepository
        self.commentRepository = commentRepository
        self.setRepository = setRepository
    }
    
    func fetchTopic(topicId: String) async -> Result<Topic, APIError> {
        await topicRepository.fetchTopic(topicId: topicId)
    }
    
    func fetchSetComments(setId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await commentRepository.fetchSetComments(setId: setId, offset: offset)
    }
    
    func fetchPickedSet(topicId: String) async -> Result<PickSet?, APIError> {
        await setRepository.fetchPickedSet(topicId: topicId)
    }
    
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError> {
        await commentRepository.likeComment(LikeBody(setId: setId, commentId: commentId))
    }
}

//
//  TopicTopUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/15.
//

import Foundation

protocol TopicTopUseCase {
    func fetchTopic(topicId: String) async -> Result<Topic, APIError>
}

final class TopicTopUseCaseImpl: TopicTopUseCase {
    private let topicRepository: any TopicRepository
    
    init(topicRepository: some TopicRepository) {
        self.topicRepository = topicRepository
    }
    
    func fetchTopic(topicId: String) async -> Result<Topic, APIError> {
        await topicRepository.fetchTopic(topicId: topicId)
    }
}

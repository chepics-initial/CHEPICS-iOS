//
//  CreateTopicUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/04.
//

import Foundation

protocol CreateTopicUseCase {
    func createTopic(title: String, link: String?, description: String?, images: [Data]?) async -> Result<Void, APIError>
}

final class CreateTopicUseCaseImpl: CreateTopicUseCase {
    private let topicRepository: any TopicRepository
    
    init(topicRepository: some TopicRepository) {
        self.topicRepository = topicRepository
    }
    
    func createTopic(title: String, link: String?, description: String?, images: [Data]?) async -> Result<Void, APIError> {
        await topicRepository.createTopic(title: title, link: link, description: description, images: images)
    }
}

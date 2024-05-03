//
//  CreateTopicUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/04.
//

import Foundation

protocol CreateTopicUseCase {
}

final class CreateTopicUseCaseImpl: CreateTopicUseCase {
    private let topicRepository: any TopicRepository
    
    init(topicRepository: some TopicRepository) {
        self.topicRepository = topicRepository
    }
}

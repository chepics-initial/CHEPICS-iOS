//
//  FeedUseCase.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

protocol FeedUseCase {
    func fetchFavoriteTopics() async -> Result<[Topic], APIError>
}

final class FeedUseCaseImpl: FeedUseCase {
    private let topicRepository: any TopicRepository
    
    init(topicRepository: some TopicRepository) {
        self.topicRepository = topicRepository
    }
    
    func fetchFavoriteTopics() async -> Result<[Topic], APIError> {
        await topicRepository.fetchFavoriteTopics()
    }
}

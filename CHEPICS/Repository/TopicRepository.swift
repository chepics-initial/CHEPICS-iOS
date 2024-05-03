//
//  TopicRepository.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

protocol TopicRepository {
    func fetchFavoriteTopics() async -> Result<[Topic], APIError>
    func fetchUserTopics(userId: String, offset: Int?) async -> Result<[Topic], APIError>
}

final class TopicRepositoryImpl: TopicRepository {
    private let topicDataSource: any TopicDataSource
    
    init(topicDataSource: some TopicDataSource) {
        self.topicDataSource = topicDataSource
    }
    
    func fetchFavoriteTopics() async -> Result<[Topic], APIError> {
        await topicDataSource.fetchFavoriteTopics()
    }
    
    func fetchUserTopics(userId: String, offset: Int?) async -> Result<[Topic], APIError> {
        await topicDataSource.fetchUserTopics(userId: userId, offset: offset)
    }
}

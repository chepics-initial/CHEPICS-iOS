//
//  TopicDataSource.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

protocol TopicDataSource {
    func fetchFavoriteTopics(offset: Int?) async -> Result<[Topic], APIError>
    func fetchUserTopics(userId: String, offset: Int?) async -> Result<[Topic], APIError>
    func fetchTopic(topicId: String) async -> Result<Topic, APIError>
}

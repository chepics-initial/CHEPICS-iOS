//
//  TopicRemoteSource.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

final class TopicRemoteSource: TopicDataSource {
    static let shared = TopicRemoteSource()
    
    private init() {}
    
    func fetchFavoriteTopics(offset: Int?) async -> Result<[Topic], APIError> {
        var query: [String: Any] = [:]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .topics), responseType: Items<Topic>.self, queryParameters: query).map(\.items)
    }
    
    func fetchUserTopics(userId: String, offset: Int?) async -> Result<[Topic], APIError> {
        var query: [String: Any] = ["user_id": userId]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .userTopics), responseType: Items<Topic>.self, queryParameters: query).map(\.items)
    }
    
    func fetchTopic(topicId: String) async -> Result<Topic, APIError> {
        await API.request(ServerDirection.production.urlString(for: .topic), responseType: Topic.self, queryParameters: ["topic_id": topicId])
    }
    
    func createTopic(
        title: String,
        link: String?,
        description: String?,
        images: [Data]?
    ) async -> Result<Void, APIError> {
        await API.createTopic(
            title: title,
            link: link,
            description: description,
            images: images,
            ServerDirection.production.urlString(for: .topic),
            responseType: CreateTopicResponse.self
        ).map { _ in }
    }
}

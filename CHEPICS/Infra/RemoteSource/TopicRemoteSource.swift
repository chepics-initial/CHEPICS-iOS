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
        return await API.request(ServerDirection.production.urlString(for: .topics), responseType: [Topic].self, queryParameters: query)
    }
    
    func fetchUserTopics(userId: String, offset: Int?) async -> Result<[Topic], APIError> {
        var query: [String: Any] = ["user_id": userId]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .userTopics), responseType: [Topic].self, queryParameters: query)
    }
}

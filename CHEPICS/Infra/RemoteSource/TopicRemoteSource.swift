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
    
    func fetchFavoriteTopics() async -> Result<[Topic], APIError> {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        return .success([mockTopic1, mockTopic2, mockTopic3, mockTopic4, mockTopic5, mockTopic6, mockTopic7, mockTopic8, mockTopic9, mockTopic10, mockTopic11, mockTopic12, mockTopic13, mockTopic14, mockTopic15])
    }
}
//
//  TopicRepository.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

protocol TopicRepository {
    func fetchFavoriteTopics(offset: Int?) async -> Result<[Topic], APIError>
    func fetchUserTopics(userId: String, offset: Int?) async -> Result<[Topic], APIError>
    func fetchTopic(topicId: String) async -> Result<Topic, APIError>
    func createTopic(title: String, link: String?, description: String?, images: [Data]?) async -> Result<Void, APIError>
}

final class TopicRepositoryImpl: TopicRepository {
    private let topicDataSource: any TopicDataSource
    private let tokenDataSource: any TokenDataSource
    
    init(topicDataSource: some TopicDataSource, tokenDataSource: some TokenDataSource) {
        self.topicDataSource = topicDataSource
        self.tokenDataSource = tokenDataSource
    }
    
    func fetchFavoriteTopics(offset: Int?) async -> Result<[Topic], APIError> {
        await resultHandle(result: topicDataSource.fetchFavoriteTopics(offset: offset))
    }
    
    func fetchUserTopics(userId: String, offset: Int?) async -> Result<[Topic], APIError> {
        await resultHandle(result: topicDataSource.fetchUserTopics(userId: userId, offset: offset))
    }
    
    func fetchTopic(topicId: String) async -> Result<Topic, APIError> {
        await resultHandle(result: topicDataSource.fetchTopic(topicId: topicId))
    }
    
    func createTopic(title: String, link: String?, description: String?, images: [Data]?) async -> Result<Void, APIError> {
        await resultHandle(result: topicDataSource.createTopic(title: title, link: link, description: description, images: images))
    }
    
    private func resultHandle<T>(result: Result<T, APIError>) -> Result<T, APIError> {
        switch result {
        case .success(let success):
            return .success(success)
        case .failure(let error):
            tokenExpiredHandle(error: error)
            return .failure(error)
        }
    }
    
    private func tokenExpiredHandle(error: APIError) {
        if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_REFRESH_TOKEN {
            tokenDataSource.removeToken()
        }
    }
}

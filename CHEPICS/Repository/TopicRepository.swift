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
}

final class TopicRepositoryImpl: TopicRepository {
    private let topicDataSource: any TopicDataSource
    private let tokenDataSource: any TokenDataSource
    
    init(topicDataSource: some TopicDataSource, tokenDataSource: some TokenDataSource) {
        self.topicDataSource = topicDataSource
        self.tokenDataSource = tokenDataSource
    }
    
    func fetchFavoriteTopics(offset: Int?) async -> Result<[Topic], APIError> {
        switch await topicDataSource.fetchFavoriteTopics(offset: offset) {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_ACCESS_TOKEN {
                tokenDataSource.removeToken()
            }
            return .failure(error)
        }
    }
    
    func fetchUserTopics(userId: String, offset: Int?) async -> Result<[Topic], APIError> {
        switch await topicDataSource.fetchUserTopics(userId: userId, offset: offset) {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_ACCESS_TOKEN {
                tokenDataSource.removeToken()
            }
            return .failure(error)
        }
    }
}

//
//  SearchRepository.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/26.
//

import Foundation

protocol SearchRepository {
    func fetchSearchedTopics(word: String, offset: Int?) async -> Result<[Topic], APIError>
    func fetchSearchedComments(word: String, offset: Int?) async -> Result<[Comment], APIError>
    func fetchSearchedUsers(word: String, offset: Int?) async -> Result<[User], APIError>
}

final class SearchRepositoryImpl: SearchRepository {
    private let searchDataSource: any SearchDataSource
    private let tokenDataSource: any TokenDataSource
    
    init(searchDataSource: some SearchDataSource, tokenDataSource: some TokenDataSource) {
        self.searchDataSource = searchDataSource
        self.tokenDataSource = tokenDataSource
    }
    
    func fetchSearchedTopics(word: String, offset: Int?) async -> Result<[Topic], APIError> {
        await resultHandle(result: searchDataSource.fetchSearchedTopics(word: word, offset: offset))
    }
    
    func fetchSearchedComments(word: String, offset: Int?) async -> Result<[Comment], APIError> {
        await resultHandle(result: searchDataSource.fetchSearchedComments(word: word, offset: offset))
    }
    
    func fetchSearchedUsers(word: String, offset: Int?) async -> Result<[User], APIError> {
        await resultHandle(result: searchDataSource.fetchSearchedUsers(word: word, offset: offset))
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

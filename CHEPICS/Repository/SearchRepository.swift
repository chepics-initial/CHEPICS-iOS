//
//  SearchRepository.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/26.
//

import Foundation

protocol SearchRepository {
    func fetchSearchedTopics(word: String) async -> Result<[Topic], APIError>
    func fetchSearchedComments(word: String) async -> Result<[Comment], APIError>
    func fetchSearchedUsers(word: String) async -> Result<[User], APIError>
}

final class SearchRepositoryImpl: SearchRepository {
    private let searchDataSource: any SearchDataSource
    private let tokenDataSource: any TokenDataSource
    
    init(searchDataSource: some SearchDataSource, tokenDataSource: some TokenDataSource) {
        self.searchDataSource = searchDataSource
        self.tokenDataSource = tokenDataSource
    }
    
    func fetchSearchedTopics(word: String) async -> Result<[Topic], APIError> {
        switch await searchDataSource.fetchSearchedTopics(word: word) {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_ACCESS_TOKEN {
                tokenDataSource.removeToken()
            }
            return .failure(error)
        }
    }
    
    func fetchSearchedComments(word: String) async -> Result<[Comment], APIError> {
        switch await searchDataSource.fetchSearchedComments(word: word) {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_ACCESS_TOKEN {
                tokenDataSource.removeToken()
            }
            return .failure(error)
        }
    }
    
    func fetchSearchedUsers(word: String) async -> Result<[User], APIError> {
        switch await searchDataSource.fetchSearchedUsers(word: word) {
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

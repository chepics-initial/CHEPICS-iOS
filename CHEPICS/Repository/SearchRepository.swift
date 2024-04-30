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
    
    init(searchDataSource: some SearchDataSource) {
        self.searchDataSource = searchDataSource
    }
    
    func fetchSearchedTopics(word: String) async -> Result<[Topic], APIError> {
        await searchDataSource.fetchSearchedTopics(word: word)
    }
    
    func fetchSearchedComments(word: String) async -> Result<[Comment], APIError> {
        await searchDataSource.fetchSearchedComments(word: word)
    }
    
    func fetchSearchedUsers(word: String) async -> Result<[User], APIError> {
        await searchDataSource.fetchSearchedUsers(word: word)
    }
}

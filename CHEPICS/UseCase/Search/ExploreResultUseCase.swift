//
//  ExploreResultUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/26.
//

import Foundation

protocol ExploreResultUseCase {
    func fetchSearchedTopics(word: String) async -> Result<[Topic], APIError>
    func fetchSearchedComments(word: String) async -> Result<[Comment], APIError>
    func fetchSearchedUsers(word: String) async -> Result<[User], APIError>
}

final class ExploreResultUseCaseImpl: ExploreResultUseCase {
    private let searchRepository: any SearchRepository
    
    init(searchRepository: some SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func fetchSearchedTopics(word: String) async -> Result<[Topic], APIError> {
        await searchRepository.fetchSearchedTopics(word: word)
    }
    
    func fetchSearchedComments(word: String) async -> Result<[Comment], APIError> {
        await searchRepository.fetchSearchedComments(word: word)
    }
    
    func fetchSearchedUsers(word: String) async -> Result<[User], APIError> {
        await searchRepository.fetchSearchedUsers(word: word)
    }
}

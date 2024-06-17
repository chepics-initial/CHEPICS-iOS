//
//  ExploreResultUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/26.
//

import Foundation

protocol ExploreResultUseCase {
    func fetchSearchedTopics(word: String, offset: Int?) async -> Result<[Topic], APIError>
    func fetchSearchedComments(word: String, offset: Int?) async -> Result<[Comment], APIError>
    func fetchSearchedUsers(word: String, offset: Int?) async -> Result<[User], APIError>
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError>
}

final class ExploreResultUseCaseImpl: ExploreResultUseCase {
    private let searchRepository: any SearchRepository
    private let commentRepository: any CommentRepository
    
    init(searchRepository: some SearchRepository, commentRepository: some CommentRepository) {
        self.searchRepository = searchRepository
        self.commentRepository = commentRepository
    }
    
    func fetchSearchedTopics(word: String, offset: Int?) async -> Result<[Topic], APIError> {
        await searchRepository.fetchSearchedTopics(word: word, offset: offset)
    }
    
    func fetchSearchedComments(word: String, offset: Int?) async -> Result<[Comment], APIError> {
        await searchRepository.fetchSearchedComments(word: word, offset: offset)
    }
    
    func fetchSearchedUsers(word: String, offset: Int?) async -> Result<[User], APIError> {
        await searchRepository.fetchSearchedUsers(word: word, offset: offset)
    }
    
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError> {
        await commentRepository.likeComment(LikeBody(setId: setId, commentId: commentId))
    }
}

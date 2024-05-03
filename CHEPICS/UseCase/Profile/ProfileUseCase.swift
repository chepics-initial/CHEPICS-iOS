//
//  ProfileUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/22.
//

import Foundation

protocol ProfileUseCase {
    func fetchUserInformation(userId: String) async -> Result<User, APIError>
    func fetchUserTopics(userId: String, offset: Int?) async -> Result<[Topic], APIError>
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError>
}

final class ProfileUseCaseImpl: ProfileUseCase {
    private let userRepository: any UserRepository
    private let topicRepository: any TopicRepository
    private let commentRepository: any CommentRepository
    
    init(
        userRepository: some UserRepository,
        topicRepository: some TopicRepository,
        commentRepository: some CommentRepository
    ) {
        self.userRepository = userRepository
        self.topicRepository = topicRepository
        self.commentRepository = commentRepository
    }
    
    func fetchUserInformation(userId: String) async -> Result<User, APIError> {
        await userRepository.fetchUser(userId: userId)
    }
    
    func fetchUserTopics(userId: String, offset: Int?) async -> Result<[Topic], APIError> {
        await topicRepository.fetchUserTopics(userId: userId, offset: offset)
    }
    
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError> {
        await commentRepository.fetchUserComments(userId: userId, offset: offset)
    }
}

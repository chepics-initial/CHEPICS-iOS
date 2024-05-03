//
//  DIFactory.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI

enum DIFactory {}

extension DIFactory {
    // MARK: - UseCase
    static func loginUseCase() -> some LoginUseCase {
        LoginUseCaseImpl(authRepository: sharedAuthRepository)
    }
    
    static func emailRegistrationUseCase() -> some EmailRegistrationUseCase {
        EmailRegistrationUseCaseImpl(authRepository: sharedAuthRepository)
    }
    
    static func oneTimeCodeUseCase() -> some OneTimeCodeUseCase {
        OneTimeCodeUseCaseImpl(authRepository: sharedAuthRepository)
    }
    
    static func passwordRegistrationUseCase() -> some PasswordRegistrationUseCase {
        PasswordRegistrationUseCaseImpl(authRepository: sharedAuthRepository)
    }
    
    static func nameRegistrationUseCase() -> some NameRegistrationUseCase {
        NameRegistrationUseCaseImpl()
    }
    
    static func feedUseCase() -> some FeedUseCase {
        FeedUseCaseImpl(topicRepository: sharedTopicRepository, commentRepository: sharedCommentRepository)
    }
    
    static func profileUseCase() -> some ProfileUseCase {
        ProfileUseCaseImpl(userRepository: sharedUserRepository, topicRepository: sharedTopicRepository, commentRepository: sharedCommentRepository)
    }
    
    static func exploreResultUseCase() -> some ExploreResultUseCase {
        ExploreResultUseCaseImpl(searchRepository: sharedSearchRepository)
    }
    
    static func tokenUseCase() -> some TokenUseCase {
        TokenUseCaseImpl(tokenRepository: sharedTokenRepository)
    }
    
    static func mainTabUseCase() -> some MainTabUseCase {
        MainTabUseCaseImpl(userRepository: sharedUserRepository)
    }
    
    // MARK: - Repository
    static let sharedTopicRepository: some TopicRepository = TopicRepositoryImpl(topicDataSource: sharedTopicDataSource, tokenDataSource: sharedTokenDataSource)
    
    static let sharedAuthRepository: some AuthRepository = AuthRepositoryImpl(authDataSource: sharedAuthDataSource, tokenDataSource: sharedTokenDataSource)
    
    static let sharedSearchRepository: some SearchRepository = SearchRepositoryImpl(searchDataSource: sharedSearchDataSource, tokenDataSource: sharedTokenDataSource)
    
    static let sharedCommentRepository: some CommentRepository = CommentRepositoryImpl(commentDataSource: sharedCommentDataSource, tokenDataSource: sharedTokenDataSource)
    
    static let sharedUserRepository: some UserRepository = UserRepositoryImpl(userDataSource: sharedUserDataSource, userStoreDataSource: sharedUserStoreDataSource, tokenDataSource: sharedTokenDataSource)
    
    static let sharedTokenRepository: some TokenRepository = TokenRepositoryImpl(tokenDataSource: sharedTokenDataSource)
    
    // MARK: - DataSource
    static let sharedTopicDataSource: some TopicDataSource = TopicRemoteSource.shared
    
    static let sharedAuthDataSource: some AuthDataSource = AuthRemoteSource.shared
    
    static let sharedTokenDataSource: some TokenDataSource = TokenStoreLocalSource.shared
    
    static let sharedSearchDataSource: some SearchDataSource = SearchRemoteSource.shared
    
    static let sharedCommentDataSource: some CommentDataSource = CommentRemoteSource.shared
    
    static let sharedUserDataSource: some UserDataSource = UserRemoteSource.shared
    
    static let sharedUserStoreDataSource: some UserStoreDataSource = UserStoreLocalSource.shared
}

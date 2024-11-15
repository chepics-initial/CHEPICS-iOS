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
        NameRegistrationUseCaseImpl(userRepository: sharedUserRepository)
    }
    
    static func feedUseCase() -> some FeedUseCase {
        FeedUseCaseImpl(topicRepository: sharedTopicRepository, commentRepository: sharedCommentRepository)
    }
    
    static func profileUseCase() -> some ProfileUseCase {
        ProfileUseCaseImpl(userRepository: sharedUserRepository, topicRepository: sharedTopicRepository, commentRepository: sharedCommentRepository)
    }
    
    static func exploreResultUseCase() -> some ExploreResultUseCase {
        ExploreResultUseCaseImpl(searchRepository: sharedSearchRepository, commentRepository: sharedCommentRepository)
    }
    
    static func tokenUseCase() -> some TokenUseCase {
        TokenUseCaseImpl(tokenRepository: sharedTokenRepository)
    }
    
    static func mainTabUseCase() -> some MainTabUseCase {
        MainTabUseCaseImpl(userRepository: sharedUserRepository)
    }
    
    static func myPageTopUseCase() -> some MyPageTopUseCase {
        MyPageTopUseCaseImpl(userRepository: sharedUserRepository, authRepository: sharedAuthRepository)
    }
    
    static func createTopicUseCase() -> some CreateTopicUseCase {
        CreateTopicUseCaseImpl(topicRepository: sharedTopicRepository)
    }
    
    static func topicTopUseCase() -> some TopicTopUseCase {
        TopicTopUseCaseImpl(topicRepository: sharedTopicRepository, commentRepository: sharedCommentRepository, setRepository: sharedSetRepository)
    }
    
    static func topicSetListUseCase() -> some TopicSetListUseCase {
        TopicSetListUseCaseImpl(setRepository: sharedSetRepository)
    }
    
    static func createSetUseCase() -> some CreateSetUseCase {
        CreateSetUseCaseImpl(setRepository: sharedSetRepository)
    }
    
    static func commentDetailUseCase() -> some CommentDetailUseCase {
        CommentDetailUseCaseImpl(commentRepository: sharedCommentRepository, setRepository: sharedSetRepository)
    }
    
    static func setCommentUseCase() -> some SetCommentUseCase {
        SetCommentUseCaseImpl(setRepository: sharedSetRepository, commentRepository: sharedCommentRepository)
    }
    
    static func setCommentDetailUseCase() -> some SetCommentDetailUseCase {
        SetCommentDetailUseCaseImpl(setRepository: sharedSetRepository, commentRepository: sharedCommentRepository)
    }
    
    static func createCommentUseCase() -> some CreateCommentUseCase {
        CreateCommentUseCaseImpl(commentRepository: sharedCommentRepository)
    }
    
    static func iconRegistrationUseCase() -> some IconRegistrationUseCase {
        IconRegistrationUseCaseImpl(authRepository: sharedAuthRepository, userRepository: sharedUserRepository)
    }
    
    static func completeRegistrationUseCase() -> some CompleteRegistrationUseCase {
        CompleteRegistrationUseCaseImpl(authRepository: sharedAuthRepository)
    }
    
    static func editProfileUseCase() -> some EditProfileUseCase {
        EditProfileUseCaseImpl(userRepository: sharedUserRepository)
    }
    
    static func splashUseCase() -> some SplashUseCase {
        SplashUseCaseImpl(splashRepository: sharedSplashRepository)
    }
    
    static func myPageTopicListUseCase() -> some MyPageTopicListUseCase {
        MyPageTopicListUseCaseImpl(setRepository: sharedSetRepository)
    }
    
    // MARK: - Repository
    static let sharedTopicRepository: some TopicRepository = TopicRepositoryImpl(topicDataSource: sharedTopicDataSource, tokenDataSource: sharedTokenDataSource)
    
    static let sharedAuthRepository: some AuthRepository = AuthRepositoryImpl(authDataSource: sharedAuthDataSource, tokenDataSource: sharedTokenDataSource, userStoreDataSource: sharedUserStoreDataSource)
    
    static let sharedSearchRepository: some SearchRepository = SearchRepositoryImpl(searchDataSource: sharedSearchDataSource, tokenDataSource: sharedTokenDataSource)
    
    static let sharedCommentRepository: some CommentRepository = CommentRepositoryImpl(commentDataSource: sharedCommentDataSource, tokenDataSource: sharedTokenDataSource)
    
    static let sharedUserRepository: some UserRepository = UserRepositoryImpl(userDataSource: sharedUserDataSource, userStoreDataSource: sharedUserStoreDataSource, tokenDataSource: sharedTokenDataSource)
    
    static let sharedTokenRepository: some TokenRepository = TokenRepositoryImpl(tokenDataSource: sharedTokenDataSource)
    
    static let sharedSetRepository: some SetRepository = SetRepositoryImpl(setDataSource: sharedSetDataSource,tokenDataSource: sharedTokenDataSource)
    
    static let sharedSplashRepository: some SplashRepository = SplashRepositoryImpl(splashDataSource: sharedSplashDataSource)
    
    // MARK: - DataSource
    static let sharedTopicDataSource: some TopicDataSource = TopicRemoteSource.shared
    
    static let sharedAuthDataSource: some AuthDataSource = AuthRemoteSource.shared
    
    static let sharedTokenDataSource: some TokenDataSource = TokenStoreLocalSource.shared
    
    static let sharedSearchDataSource: some SearchDataSource = SearchRemoteSource.shared
    
    static let sharedCommentDataSource: some CommentDataSource = CommentRemoteSource.shared
    
    static let sharedUserDataSource: some UserDataSource = UserRemoteSource.shared
    
    static let sharedUserStoreDataSource: some UserStoreDataSource = UserStoreLocalSource.shared
    
    static let sharedSetDataSource: some SetDataSource = SetRemoteSource.shared
    
    static let sharedSplashDataSource: some SplashDataSource = SplashLocalSource.shared
}

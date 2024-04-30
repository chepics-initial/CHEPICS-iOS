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
        FeedUseCaseImpl(topicRepository: sharedTopicRepository)
    }
    
    static func profileUseCase() -> some ProfileUseCase {
        ProfileUseCaseImpl()
    }
    
    static func exploreResultUseCase() -> some ExploreResultUseCase {
        ExploreResultUseCaseImpl(searchRepository: sharedSearchRepository)
    }
    
    // MARK: - Repository
    static let sharedTopicRepository: some TopicRepository = TopicRepositoryImpl(topicDataSource: sharedTopicDataSource)
    
    static let sharedAuthRepository: some AuthRepository = AuthRepositoryImpl(authDataSource: sharedAuthDataSource, tokenDataSource: sharedTokenDataSource)
    
    static let sharedSearchRepository: some SearchRepository = SearchRepositoryImpl(searchDataSource: sharedSearchDataSource)
    
    // MARK: - DataSource
    static let sharedTopicDataSource: some TopicDataSource = TopicRemoteSource.shared
    
    static let sharedAuthDataSource: some AuthDataSource = AuthRemoteSource.shared
    
    static let sharedTokenDataSource: some TokenDataSource = TokenStoreLocalSource.shared
    
    static let sharedSearchDataSource: some SearchDataSource = SearchRemoteSource.shared
}

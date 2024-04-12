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
        LoginUseCaseImpl()
    }
    
    static func emailRegistrationUseCase() -> some EmailRegistrationUseCase {
        EmailRegistrationUseCaseImpl(authRepository: sharedAuthRepository)
    }
    
    static func oneTimeCodeUseCase() -> some OneTimeCodeUseCase {
        OneTimeCodeUseCaseImpl(authRepository: sharedAuthRepository)
    }
    
    static func passwordRegistrationUseCase() -> some PasswordRegistrationUseCase {
        PasswordRegistrationUseCaseImpl(createUserRepository: sharedCreateUserRepository)
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
    
    // MARK: - Repository
    static let sharedCreateUserRepository: some CreateUserRepository = CreateUserRepositoryImpl()
    
    static let sharedTopicRepository: some TopicRepository = TopicRepositoryImpl(topicDataSource: sharedTopicDataSource)
    
    static let sharedAuthRepository: some AuthRepository = AuthRepositoryImpl(authDataSource: sharedAuthDataSource)
    
    // MARK: - DataSource
    static let sharedTopicDataSource: some TopicDataSource = TopicRemoteSource.shared
    
    static let sharedAuthDataSource: some AuthDataSource = AuthRemoteSource.shared
}

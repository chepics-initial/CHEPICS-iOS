//
//  DIFactory.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI

enum DIFactory {}

extension DIFactory {
    // MARK: - Controller
    static let sharedControllerHelper = ControllerHelper(requestHeaderController: sharedRequestHeaderController)
    
    static let sharedRequestHeaderController = RequestHeaderController(requestHeaderUseCase: sharedRequestHeaderUseCase)
    
    // MARK: - UseCase
    static func loginUseCase() -> some LoginUseCase {
        LoginUseCaseImpl()
    }
    
    static func emailRegistrationUseCase() -> some EmailRegistrationUseCase {
        EmailRegistrationUseCaseImpl()
    }
    
    static func oneTimeCodeUseCase() -> some OneTimeCodeUseCase {
        OneTimeCodeUseCaseImpl()
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
    
    static let sharedRequestHeaderUseCase: some RequestHeaderUseCase =
        RequestHeaderUseCaseImpl(requestHeaderRepository: sharedRequestHeaderRepository, authRepository: sharedAuthRepository)
    
    // MARK: - Repository
    static let sharedCreateUserRepository: some CreateUserRepository = CreateUserRepositoryImpl()
    
    static let sharedRequestHeaderRepository: some RequestHeaderRepository = RequestHeaderRepositoryImpl(requestHeaderDataSource: sharedRequestHeaderDataSource)
    
    static let sharedAuthRepository: some AuthRepository = AuthRepositoryImpl(bffAuthTokenStoreDataSource: sharedBFFAuthTokenStoreDataSource)
    
    static let sharedTopicRepository: some TopicRepository = TopicRepositoryImpl(topicDataSource: sharedTopicDataSource)
    
    // MARK: - DataSource
    static let sharedRequestHeaderDataSource = RequestHeader.shared
    
    static let sharedBFFAuthTokenStoreDataSource: some BFFAuthTokenStoreDataSource = BFFAuthTokenStoreLocalSource.shared
    
    static let sharedTopicDataSource: some TopicDataSource = TopicRemoteSource.shared
}

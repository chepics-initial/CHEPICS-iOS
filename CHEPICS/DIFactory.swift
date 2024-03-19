//
//  DIFactory.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI

enum DIFactory {}

extension DIFactory {
    // MARK: - ViewModel
    @MainActor static func loginViewModel() -> LoginViewModelImpl {
        LoginViewModelImpl(loginUseCase: loginUseCase())
    }
    
    @MainActor static func emailRegstrationViewModel() -> EmailRegistrationViewModelImpl {
        EmailRegistrationViewModelImpl(emailRegistrationUseCase: emailRegistrationUseCase())
    }
    
    @MainActor static func oneTimeCodeViewModel(email: String) -> OneTimeCodeViewModelImpl {
        OneTimeCodeViewModelImpl(email: email, oneTimeCodeUseCase: oneTimeCodeUseCase())
    }
    
    @MainActor static func passwordRegistrationViewModel() -> PasswordRegistrationViewModelImpl {
        PasswordRegistrationViewModelImpl(passwordRegistrationUseCase: passwordRegistrationUseCase())
    }
    
    @MainActor static func nameRegistrationViewModel() -> NameRegistrationViewModelImpl {
        NameRegistrationViewModelImpl(nameRegistrationUseCase: nameRegistrationUseCase())
    }
    
    @MainActor static func iconRegistrationViewModel() -> IconRegistrationViewModelImpl {
        IconRegistrationViewModelImpl()
    }
    
    @MainActor static func createTopicViewModel() -> CreateTopicViewModelImpl {
        CreateTopicViewModelImpl()
    }
    
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
    
    static let sharedRequestHeaderUseCase: some RequestHeaderUseCase =
        RequestHeaderUseCaseImpl(requestHeaderRepository: sharedRequestHeaderRepository, authRepository: sharedAuthRepository)
    
    // MARK: - Repository
    static let sharedCreateUserRepository: some CreateUserRepository = CreateUserRepositoryImpl()
    
    static let sharedRequestHeaderRepository: some RequestHeaderRepository = RequestHeaderRepositoryImpl(requestHeaderDataSource: sharedRequestHeaderDataSource)
    
    static let sharedAuthRepository: some AuthRepository = AuthRepositoryImpl(bffAuthTokenStoreDataSource: sharedBFFAuthTokenStoreDataSource)
    
    // MARK: - DataSource
    static let sharedRequestHeaderDataSource = RequestHeader.shared
    
    static let sharedBFFAuthTokenStoreDataSource: some BFFAuthTokenStoreDataSource = BFFAuthTokenStoreLocalSource.shared
}

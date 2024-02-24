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
        LoginViewModelImpl()
    }
    
    @MainActor static func emailRegstrationViewModel() -> EmailRegistrationViewModelImpl {
        EmailRegistrationViewModelImpl(emailRegistrationUseCase: emailRegistrationUseCase())
    }
    
    @MainActor static func oneTimeCodeViewModel(email: String) -> OneTimeCodeViewModelImpl {
        OneTimeCodeViewModelImpl(email: email, oneTimeCodeUseCase: oneTimeCodeUseCase())
    }
    
    // MARK: - UseCase
    static func emailRegistrationUseCase() -> some EmailRegistrationUseCase {
        EmailRegistrationUseCaseImpl()
    }
    
    static func oneTimeCodeUseCase() -> some OneTimeCodeUseCase {
        OneTimeCodeUseCaseImpl()
    }
}

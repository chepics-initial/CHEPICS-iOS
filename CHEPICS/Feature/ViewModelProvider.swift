//
//  ViewModelProvider.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI

protocol ViewModelProvider {
    @MainActor func loginViewModel() -> LoginViewModelImpl
    @MainActor func emailRegistrationViewModel() -> EmailRegistrationViewModelImpl
    @MainActor func oneTimeCodeViewModel(email: String) -> OneTimeCodeViewModelImpl
    @MainActor func passwordRegistrationViewModel() -> PasswordRegistrationViewModelImpl
}

final class ViewModelProviderImpl: ViewModelProvider {
    @MainActor func loginViewModel() -> LoginViewModelImpl {
        DIFactory.loginViewModel()
    }
    
    @MainActor func emailRegistrationViewModel() -> EmailRegistrationViewModelImpl {
        DIFactory.emailRegstrationViewModel()
    }
    
    @MainActor func oneTimeCodeViewModel(email: String) -> OneTimeCodeViewModelImpl {
        DIFactory.oneTimeCodeViewModel(email: email)
    }
    
    @MainActor func passwordRegistrationViewModel() -> PasswordRegistrationViewModelImpl {
        DIFactory.passwordRegistrationViewModel()
    }
}

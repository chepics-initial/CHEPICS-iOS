//
//  LoginViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/21.
//

import Foundation

@MainActor final class LoginViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    @Published var showInvalidAlert: Bool = false
    var loginButtonIsActive: Bool {
        !email.isEmpty && password.count >= Constants.passwordCount
    }
    
    private let loginUseCase: any LoginUseCase
    
    init(loginUseCase: some LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func onTapLoginButton() async {
        isLoading = true
        let result = await loginUseCase.login(email: email, password: password)
        isLoading = false
        switch result {
        case .success:
            return
        case .failure(let error):
            switch error {
            case .decodingError, .networkError, .invalidStatus, .otherError:
                showAlert = true
            case .errorResponse(let errorResponse, _):
                if errorResponse.errorCode == .EMAIL_OR_PASSWORD_INCORRECT {
                    showInvalidAlert = true
                    return
                }
                showAlert = true
            }
        }
    }
}

final class LoginUseCase_Previews: LoginUseCase {
    func login(email: String, password: String) async -> Result<Void, APIError> {
        .success(())
    }
}

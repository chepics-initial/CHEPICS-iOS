//
//  LoginViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/21.
//

import Foundation

@MainActor protocol LoginViewModel: ObservableObject {
    var isLoading: Bool { get }
    var email: String { get set }
    var password: String { get set }
    var loginButtonIsActive: Bool { get }
    var showAlert: Bool { get set }
    func onTapLoginButton() async
}

@MainActor final class LoginViewModelImpl: LoginViewModel {
    @Published private(set) var isLoading: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
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
        case .failure:
            showAlert = true
        }
    }
}

final class LoginViewModel_Previews: LoginViewModel {
    var email: String = ""
    var password: String = ""
    var loginButtonIsActive: Bool = true
    var isLoading: Bool = false
    var showAlert: Bool = false
    
    init() {}
    
    func onTapLoginButton() async {
        
    }
}

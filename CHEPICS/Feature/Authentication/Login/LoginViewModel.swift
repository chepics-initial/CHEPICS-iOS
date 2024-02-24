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
    func onTapLoginButton() async
}

@MainActor final class LoginViewModelImpl: LoginViewModel {
    @Published private(set) var isLoading: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    var loginButtonIsActive: Bool {
        !email.isEmpty && password.count >= 8
    }
    
    func onTapLoginButton() async {
        isLoading = true
    }
}

final class LoginViewModel_Previews: LoginViewModel {
    var email: String = ""
    var password: String = ""
    var loginButtonIsActive: Bool = true
    var isLoading: Bool = false
    
    init() {}
    
    func onTapLoginButton() async {
        
    }
}

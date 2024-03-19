//
//  PasswordRegistrationViewModel.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import Foundation

@MainActor final class PasswordRegistrationViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isPresented: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published var showAlert: Bool = false
    var isActive: Bool {
        password.count >= Constants.passwordCount && password == confirmPassword
    }
    
    private let passwordRegistrationUseCase: any PasswordRegistrationUseCase
    
    init(passwordRegistrationUseCase: some PasswordRegistrationUseCase) {
        self.passwordRegistrationUseCase = passwordRegistrationUseCase
    }
    
    func onTapButton() async {
        isLoading = true
        let result = await passwordRegistrationUseCase.registerPassword(password: password)
        isLoading = false
        switch result {
        case .success:
            isPresented = true
        case .failure:
            showAlert = true
        }
    }
}

final class PasswordRegistrationUseCase_Previews: PasswordRegistrationUseCase {
    func registerPassword(password: String) async -> Result<Void, APIError> {
        .success(())
    }
}

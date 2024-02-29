//
//  PasswordRegistrationViewModel.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import Foundation

@MainActor protocol PasswordRegistrationViewModel: ObservableObject {
    var password: String { get set }
    var confirmPassword: String { get set }
    var isActive: Bool { get }
    var isPresented: Bool { get set }
    var isLoading: Bool { get }
    var showAlert: Bool { get set }
    func onTapButton() async
}

@MainActor final class PasswordRegistrationViewModelImpl: PasswordRegistrationViewModel {
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

final class PasswordRegistrationViewModel_Previews: PasswordRegistrationViewModel {
    var isLoading: Bool = false
    var showAlert: Bool = false    
    var password: String = ""
    var confirmPassword: String = ""
    var isActive: Bool = true
    var isPresented: Bool = false
    
    func onTapButton() {
        
    }
}

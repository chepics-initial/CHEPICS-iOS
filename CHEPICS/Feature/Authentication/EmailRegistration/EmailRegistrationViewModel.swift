//
//  EmailRegistrationViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import Foundation

@MainActor protocol EmailRegistrationViewModel: ObservableObject {
    var isLoading: Bool { get }
    var email: String { get set }
    var isActive: Bool { get }
    var isPresented: Bool { get set }
    var showAlert: Bool { get set }
    func onTapButton() async
}

@MainActor final class EmailRegistrationViewModelImpl: EmailRegistrationViewModel {
    @Published private(set) var isLoading: Bool = false
    @Published var email: String = ""
    @Published var isPresented: Bool = false
    @Published var showAlert: Bool = false
    var isActive: Bool {
        !email.isEmpty
    }
    private let emailRegistrationUseCase: any EmailRegistrationUseCase
    
    init(emailRegistrationUseCase: some EmailRegistrationUseCase) {
        self.emailRegistrationUseCase = emailRegistrationUseCase
    }

    
    func onTapButton() async {
        isLoading = true
        let result = await emailRegistrationUseCase.verifyEmail(email: email)
        isLoading = false
        switch result {
        case .success:
            isPresented = true
        case .failure:
            showAlert = true
        }
    }
}

final class EmailRegistrationViewModel_Previews: EmailRegistrationViewModel {
    var isLoading: Bool = false
    var email: String = ""
    var isActive: Bool = true
    var isPresented: Bool = false
    var showAlert: Bool = false
    func onTapButton() async {
        
    }
    
}

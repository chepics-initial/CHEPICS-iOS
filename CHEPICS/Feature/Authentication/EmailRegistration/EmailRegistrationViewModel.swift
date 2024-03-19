//
//  EmailRegistrationViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import Foundation

@MainActor final class EmailRegistrationViewModel: ObservableObject {
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

final class EmailRegistrationUseCase_Previews: EmailRegistrationUseCase {
    func verifyEmail(email: String) async -> Result<Void, APIError> {
        .success(())
    }
}

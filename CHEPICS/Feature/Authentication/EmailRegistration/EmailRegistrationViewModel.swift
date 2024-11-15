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
    @Published var showAlreadyAlert: Bool = false
    var isActive: Bool {
        !email.isEmpty
    }
    private let emailRegistrationUseCase: any EmailRegistrationUseCase
    
    init(emailRegistrationUseCase: some EmailRegistrationUseCase) {
        self.emailRegistrationUseCase = emailRegistrationUseCase
    }

    
    func onTapButton() async {
        isLoading = true
        let result = await emailRegistrationUseCase.createConfirmCode(email: email)
        isLoading = false
        switch result {
        case .success(let email):
            self.email = email
            isPresented = true
        case .failure(let error):
            switch error {
            case .errorResponse(let errorResponse, _):
                switch errorResponse.errorCode {
                case .USED_EMAIL:
                    showAlreadyAlert = true
                default:
                    showAlert = true
                }
            default:
                showAlert = true
            }
        }
    }
}

final class EmailRegistrationUseCase_Previews: EmailRegistrationUseCase {
    func createConfirmCode(email: String) async -> Result<String, APIError> {
        .success((""))
    }
}

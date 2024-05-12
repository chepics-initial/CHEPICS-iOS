//
//  OneTimeCodeViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import Foundation

@MainActor final class OneTimeCodeViewModel: ObservableObject {
    @Published var code: String = ""
    @Published private(set) var email: String
    @Published private(set) var isLoading: Bool = false
    @Published var isPresented: Bool = false
    @Published var showFailureAlert: Bool = false
    @Published var showInvalidAlert: Bool = false
    @Published var showResendToast = false
    @Published var showResendFailureToast = false
    var isActive: Bool {
        code.count >= Constants.oneTimeCodeCount
    }
    
    private let oneTimeCodeUseCase: any OneTimeCodeUseCase
    
    init(email: String, oneTimeCodeUseCase: some OneTimeCodeUseCase) {
        self.email = email
        self.oneTimeCodeUseCase = oneTimeCodeUseCase
    }
    
    func getCodeIndex(index: Int) -> String {
        if code.count > index {
            let start = code.startIndex
            let current = code.index(start, offsetBy: index)
            return String(code[current])
        }
        
        return ""
    }
    
    func onTapNextButton() async {
        isLoading = true
        let result = await oneTimeCodeUseCase.verifyCode(email: email, code: code)
        isLoading = false
        switch result {
        case .success:
            isPresented = true
        case .failure(let error):
            switch error {
            case .errorResponse(let errorResponse, _):
                switch errorResponse.errorCode {
                case .CODE_INCORRECT_OR_EXPIRED:
                    showInvalidAlert = true
                default:
                    showFailureAlert = true
                }
            default:
                showFailureAlert = true
            }
        }
    }
    
    func onTapResendButton() async {
        switch await oneTimeCodeUseCase.createCode(email: email) {
        case .success:
            showResendToast = true
        case .failure:
            showResendFailureToast = true
        }
    }
}

final class OneTimeCodeUseCase_Previews: OneTimeCodeUseCase {
    func verifyCode(email: String, code: String) async -> Result<Void, APIError> {
        .success(())
    }
    
    func createCode(email: String) async -> Result<Void, APIError> {
        .success(())
    }
}

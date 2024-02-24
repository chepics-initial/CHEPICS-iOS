//
//  OneTimeCodeViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import Foundation

@MainActor protocol OneTimeCodeViewModel: ObservableObject {
    var code: String { get set }
    var email: String { get }
    var isActive: Bool { get }
    var isLoading: Bool { get }
    var isPresented: Bool { get set }
    var showFailureAlert: Bool { get set }
    func getCodeIndex(index: Int) -> String
    func onTapNextButton() async
}

@MainActor final class OneTimeCodeViewModelImpl: OneTimeCodeViewModel {    
    @Published var code: String = ""
    @Published private(set) var email: String
    @Published private(set) var isLoading: Bool = false
    @Published var isPresented: Bool = false
    @Published var showFailureAlert: Bool = false
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
        let result = await oneTimeCodeUseCase.verifyCode(code: code)
        isLoading = false
        switch result {
        case .success:
            isPresented = true
        case .failure:
            showFailureAlert = true
        }
    }
}

final class OneTimeCodeViewModel_Previews: OneTimeCodeViewModel {
    var code: String = ""
    var email: String = ""
    var isActive: Bool = false
    var isLoading: Bool = false
    var isPresented: Bool = false
    var showFailureAlert: Bool = false
    
    func getCodeIndex(index: Int) -> String {
        ""
    }
    
    func onTapNextButton() async {
    }
}

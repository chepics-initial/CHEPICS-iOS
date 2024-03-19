//
//  NameRegistrationViewModel.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import Foundation

@MainActor final class NameRegistrationViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = false
    @Published var username: String = ""
    @Published var fullname: String = ""
    @Published var showAlert: Bool = false
    @Published var isPresented: Bool = false
    var isActive: Bool {
        !username.isEmpty && !fullname.isEmpty && username.count <= Constants.nameCount && fullname.count <= Constants.nameCount
    }
    
    private let nameRegistrationUseCase: any NameRegistrationUseCase
    
    init(nameRegistrationUseCase: some NameRegistrationUseCase) {
        self.nameRegistrationUseCase = nameRegistrationUseCase
    }
    
    func onTapButton() async {
        isLoading = true
        let result = await nameRegistrationUseCase.registerName(username: username, fullname: fullname)
        isLoading = false
        switch result {
        case .success:
            isPresented = true
        case .failure:
            showAlert = true
        }
    }
}

final class NameRegistrationUseCase_Previews: NameRegistrationUseCase {
    func registerName(username: String, fullname: String) async -> Result<Void, APIError> {
        .success(())
    }
}

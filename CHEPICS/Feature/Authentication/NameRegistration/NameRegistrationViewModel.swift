//
//  NameRegistrationViewModel.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import Foundation

@MainActor protocol NameRegistrationViewModel: ObservableObject {
    var isLoading: Bool { get }
    var username: String { get set }
    var fullname: String { get set }
    var showAlert: Bool { get set }
    var isActive: Bool { get }
    var isPresented: Bool { get set }
    func onTapButton() async
}

@MainActor final class NameRegistrationViewModelImpl: NameRegistrationViewModel {
    @Published private(set) var isLoading: Bool = false
    @Published var username: String = ""
    @Published var fullname: String = ""
    @Published var showAlert: Bool = false
    @Published var isPresented: Bool = false
    var isActive: Bool {
        !username.isEmpty && !fullname.isEmpty
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

final class NameRegistrationViewModel_Previews: NameRegistrationViewModel {
    var isLoading: Bool = false
    var username: String = ""
    var fullname: String = ""
    var showAlert: Bool = false
    var isActive: Bool = true
    var isPresented: Bool = false
    
    func onTapButton() async {
        
    }
}

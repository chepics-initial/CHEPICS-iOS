//
//  CompleteRegistrationViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/26.
//

import Foundation

@MainActor final class CompleteRegistrationViewModel: ObservableObject {
    private let completeRegistrationUseCase: any CompleteRegistrationUseCase
    
    init(completeRegistrationUseCase: some CompleteRegistrationUseCase) {
        self.completeRegistrationUseCase = completeRegistrationUseCase
    }
    
    func onTapSkipButton() {
        completeRegistrationUseCase.skip()
    }
}

final class CompleteRegistrationUseCase_Previews: CompleteRegistrationUseCase {
    func skip() {
        
    }
}

//
//  CreateSetViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/15.
//

import Foundation

@MainActor final class CreateSetViewModel: ObservableObject {
    @Published var setText = ""
    @Published private(set) var isLoading = false
    @Published var showAlert = false
    @Published private (set) var isCompleted = false
    var isActive: Bool {
        isValidInput(setText) && setText.count <= Constants.setCount
    }
    let topicId: String
    private let createSetUseCase: any CreateSetUseCase
    
    init(topicId: String, createSetUseCase: some CreateSetUseCase) {
        self.topicId = topicId
        self.createSetUseCase = createSetUseCase
    }
    
    func onTapButton() async {
        isLoading = true
        let result = await createSetUseCase.createSet(topicId: topicId, set: setText)
        isLoading = false
        switch result {
        case .success:
            isCompleted = true
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .UNAUTHORIZED {
                return
            }
            showAlert = true
        }
    }
}

final class CreateSetUseCase_Previews: CreateSetUseCase {
    func createSet(topicId: String, set: String) async -> Result<Void, APIError> {
        .success(())
    }
}

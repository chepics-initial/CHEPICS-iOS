//
//  CreateSetUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/19.
//

import Foundation

protocol CreateSetUseCase {
    func createSet(topicId: String, set: String) async -> Result<Void, APIError>
}

final class CreateSetUseCaseImpl: CreateSetUseCase {
    private let setRepository: any SetRepository
    
    init(setRepository: some SetRepository) {
        self.setRepository = setRepository
    }
    
    func createSet(topicId: String, set: String) async -> Result<Void, APIError> {
        await setRepository.createSet(body: CreateSetBody(topicId: topicId, setText: set))
    }
}

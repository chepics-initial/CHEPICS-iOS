//
//  TopicSetListUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/19.
//

import Foundation

protocol TopicSetListUseCase {
    func fetchSets(topicId: String) async -> Result<[PickSet], APIError>
    func pickSet(topicId: String, setId: String) async -> Result<PickSet, APIError>
}

final class TopicSetListUseCaseImpl: TopicSetListUseCase {
    private let setRepository: any SetRepository
    
    init(setRepository: some SetRepository) {
        self.setRepository = setRepository
    }
    
    func fetchSets(topicId: String) async -> Result<[PickSet], APIError> {
        await setRepository.fetchSets(topicId: topicId)
    }
    
    func pickSet(topicId: String, setId: String) async -> Result<PickSet, APIError> {
        await setRepository.pickSet(body: PickSetBody(topicId: topicId, setId: setId))
    }
}

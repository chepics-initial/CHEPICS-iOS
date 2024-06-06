//
//  MyPageTopicListUseCase.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/06/06.
//

import Foundation

protocol MyPageTopicListUseCase {
    func fetchPickedSets(offset: Int?) async -> Result<[MySet], APIError>
}

final class MyPageTopicListUseCaseImpl: MyPageTopicListUseCase {
    private let setRepository: any SetRepository
    
    init(setRepository: some SetRepository) {
        self.setRepository = setRepository
    }
    
    func fetchPickedSets(offset: Int?) async -> Result<[MySet], APIError> {
        await setRepository.fetchPickedSets(offset: offset)
    }
}

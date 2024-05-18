//
//  SetRepository.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/19.
//

import Foundation

protocol SetRepository {
    func fetchSets(topicId: String) async -> Result<[PickSet], APIError>
}

final class SetRepositoryImpl: SetRepository {
    private let setDataSource: any SetDataSource
    
    init(setDataSource: some SetDataSource) {
        self.setDataSource = setDataSource
    }
    
    func fetchSets(topicId: String) async -> Result<[PickSet], APIError> {
        await setDataSource.fetchSets(topicId: topicId)
    }
}

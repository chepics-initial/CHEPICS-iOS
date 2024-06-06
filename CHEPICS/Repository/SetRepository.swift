//
//  SetRepository.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/19.
//

import Foundation

protocol SetRepository {
    func fetchSets(topicId: String, offset: Int?) async -> Result<[PickSet], APIError>
    func createSet(body: CreateSetBody) async -> Result<Void, APIError>
    func pickSet(body: PickSetBody) async -> Result<PickSet, APIError>
    func fetchSet(setId: String) async -> Result<PickSet, APIError>
    func fetchPickedSets(offset: Int?) async -> Result<[MySet], APIError>
}

final class SetRepositoryImpl: SetRepository {
    private let setDataSource: any SetDataSource
    private let tokenDataSource: any TokenDataSource
    
    init(setDataSource: some SetDataSource, tokenDataSource: some TokenDataSource) {
        self.setDataSource = setDataSource
        self.tokenDataSource = tokenDataSource
    }
    
    func fetchSets(topicId: String, offset: Int?) async -> Result<[PickSet], APIError> {
        await resultHandle(result: setDataSource.fetchSets(topicId: topicId, offset: offset))
    }
    
    func createSet(body: CreateSetBody) async -> Result<Void, APIError> {
        await resultHandle(result: setDataSource.createSet(body: body))
    }
    
    func pickSet(body: PickSetBody) async -> Result<PickSet, APIError> {
        await resultHandle(result: setDataSource.pickSet(body: body))
    }
    
    func fetchSet(setId: String) async -> Result<PickSet, APIError> {
        await resultHandle(result: setDataSource.fetchSet(setId: setId))
    }
    
    func fetchPickedSets(offset: Int?) async -> Result<[MySet], APIError> {
        await resultHandle(result: setDataSource.fetchPickedSets(offset: offset))
    }
    
    private func resultHandle<T>(result: Result<T, APIError>) -> Result<T, APIError> {
        switch result {
        case .success(let success):
            return .success(success)
        case .failure(let error):
            tokenExpiredHandle(error: error)
            return .failure(error)
        }
    }
    
    private func tokenExpiredHandle(error: APIError) {
        if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_REFRESH_TOKEN {
            tokenDataSource.removeToken()
        }
    }
}

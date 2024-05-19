//
//  SetRemoteSource.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/19.
//

import Foundation

final class SetRemoteSource: SetDataSource {
    static let shared = SetRemoteSource()
    
    private init() {}
    
    func fetchSets(topicId: String) async -> Result<[PickSet], APIError> {
        .success([mockSet1, mockSet2, mockSet3])
//        await API.request(ServerDirection.production.urlString(for: .topicSets), responseType: Items<PickSet>.self, queryParameters: ["topic_id": topicId]).map(\.items)
    }
    
    func createSet(body: CreateSetBody) async -> Result<Void, APIError> {
        .success(())
//        await API.postRequest(ServerDirection.production.urlString(for: .createSet), responseType: String.self, httpBody: body).map { _ in }
    }
    
    func pickSet(body: PickSetBody) async -> Result<PickSet, APIError> {
        .success(mockSet1)
//        await API.postRequest(ServerDirection.production.urlString(for: .pickSet), responseType: PickSet.self, httpBody: body)
    }
}

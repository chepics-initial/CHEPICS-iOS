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
    
    func fetchSets(topicId: String, offset: Int?) async -> Result<[PickSet], APIError> {
        var query: [String: Any] = ["topic_id": topicId]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .topicSets), responseType: Items<PickSet>.self, queryParameters: query).map(\.items)
    }
    
    func createSet(body: CreateSetBody) async -> Result<Void, APIError> {
        await API.postRequest(ServerDirection.production.urlString(for: .set), responseType: CreateSetResponse.self, httpBody: body).map { _ in }
    }
    
    func pickSet(body: PickSetBody) async -> Result<PickSet, APIError> {
        await API.postRequest(ServerDirection.production.urlString(for: .pickSet), responseType: PickSet.self, httpBody: body)
    }
    
    func fetchSet(setId: String) async -> Result<PickSet, APIError> {
        await API.request(ServerDirection.production.urlString(for: .set), responseType: PickSet.self, queryParameters: ["set_id": setId])
    }
    
    func fetchPickedSets(offset: Int?) async -> Result<[MySet], APIError> {
        var query: [String: Any] = [:]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .pickedSets), responseType: Items<MySet>.self, queryParameters: query).map(\.items)
    }
}

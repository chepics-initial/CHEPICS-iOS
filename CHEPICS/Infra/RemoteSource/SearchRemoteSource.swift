//
//  SearchRemoteSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/26.
//

import Foundation

final class SearchRemoteSource: SearchDataSource {
    static let shared = SearchRemoteSource()
    
    private init() {}
    
    func fetchSearchedTopics(word: String, offset: Int?) async -> Result<[Topic], APIError> {
        var query: [String: Any] = ["word": word]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .searchTopics), responseType: Items<Topic>.self, queryParameters: query).map({ $0.items })
    }
    
    func fetchSearchedComments(word: String, offset: Int?) async -> Result<[Comment], APIError> {
        var query: [String: Any] = ["word": word]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .searchComments), responseType: Items<Comment>.self, queryParameters: query).map({ $0.items })
    }
    
    func fetchSearchedUsers(word: String, offset: Int?) async -> Result<[User], APIError> {
        var query: [String: Any] = ["word": word]
        if let offset {
            query["offset"] = offset
        }
        return await API.request(ServerDirection.production.urlString(for: .searchUsers), responseType: Items<User>.self, queryParameters: query).map({ $0.items })
    }
}

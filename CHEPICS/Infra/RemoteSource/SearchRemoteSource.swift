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
    
    func fetchSearchedTopics(word: String) async -> Result<[Topic], APIError> {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        return .success([mockTopic1, mockTopic2, mockTopic3, mockTopic4])
    }
    
    func fetchSearchedComments(word: String) async -> Result<[Comment], APIError> {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        return .success([mockComment1, mockComment2, mockComment3, mockComment4])
    }
    
    func fetchSearchedUsers(word: String) async -> Result<[User], APIError> {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        return .success([mockUser1, mockUser2, mockUser3, mockUser4])
    }
}

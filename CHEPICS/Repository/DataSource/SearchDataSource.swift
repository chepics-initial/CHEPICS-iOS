//
//  SearchDataSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/26.
//

import Foundation

protocol SearchDataSource {
    func fetchSearchedTopics(word: String, offset: Int?) async -> Result<[Topic], APIError>
    func fetchSearchedComments(word: String, offset: Int?) async -> Result<[Comment], APIError>
    func fetchSearchedUsers(word: String, offset: Int?) async -> Result<[User], APIError>
}

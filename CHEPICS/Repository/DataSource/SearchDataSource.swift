//
//  SearchDataSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/26.
//

import Foundation

protocol SearchDataSource {
    func fetchSearchedTopics(word: String) async -> Result<[Topic], APIError>
    func fetchSearchedComments(word: String) async -> Result<[Comment], APIError>
    func fetchSearchedUsers(word: String) async -> Result<[User], APIError>
}

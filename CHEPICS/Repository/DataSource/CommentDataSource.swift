//
//  CommentDataSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/03.
//

import Foundation

protocol CommentDataSource {
    func fetchFollowingComments(offset: Int?) async -> Result<[Comment], APIError>
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError>
    func fetchSetComments(setId: String) async -> Result<[Comment], APIError>
}

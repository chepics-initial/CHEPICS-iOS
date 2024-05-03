//
//  CommentDataSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/03.
//

import Foundation

protocol CommentDataSource {
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError>
}

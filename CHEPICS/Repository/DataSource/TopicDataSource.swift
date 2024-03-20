//
//  TopicDataSource.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

protocol TopicDataSource {
    func fetchFavoriteTopics() async -> Result<[Topic], APIError>
}

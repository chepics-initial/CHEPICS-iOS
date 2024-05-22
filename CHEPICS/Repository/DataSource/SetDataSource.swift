//
//  SetDataSource.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/19.
//

import Foundation

protocol SetDataSource {
    func fetchSets(topicId: String) async -> Result<[PickSet], APIError>
    func createSet(body: CreateSetBody) async -> Result<Void, APIError>
    func pickSet(body: PickSetBody) async -> Result<PickSet, APIError>
    func fetchSet(setId: String) async -> Result<PickSet, APIError>
}

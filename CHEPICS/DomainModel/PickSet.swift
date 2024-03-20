//
//  PickSet.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

struct PickSet: Decodable {
    let id: String
    let name: String
    let votes: Int
    let commentCount: String?
    
    init(id: String, name: String, votes: Int, commentCount: String?) {
        self.id = id
        self.name = name
        self.votes = votes
        self.commentCount = commentCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "setId"
        case name = "setName"
        case votes = "userPickCount"
        case commentCount
    }
}

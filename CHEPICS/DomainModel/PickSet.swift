//
//  PickSet.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

struct PickSet: Identifiable, Decodable {
    let id: String
    let name: String
    let votes: Int
    let commentCount: Int
    
    init(id: String, name: String, votes: Int, commentCount: Int) {
        self.id = id
        self.name = name
        self.votes = votes
        self.commentCount = commentCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "set_id"
        case name = "set_name"
        case votes = "user_pick_count"
        case commentCount
    }
}

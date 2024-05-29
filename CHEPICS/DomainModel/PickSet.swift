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
    let rate: Double
    
    init(id: String, name: String, votes: Int, commentCount: Int, rate: Double) {
        self.id = id
        self.name = name
        self.votes = votes
        self.commentCount = commentCount
        self.rate = rate
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "set_id"
        case name = "set_name"
        case votes = "user_pick_count"
        case commentCount = "comment_count"
        case rate = "user_pick_rate"
    }
}

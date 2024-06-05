//
//  Follow.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/06/03.
//

import Foundation

struct FollowBody: Encodable {
    let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

struct FollowResponse: Decodable {
    let userId: String
    let isFollow: Bool
    
    init(userId: String, isFollow: Bool) {
        self.userId = userId
        self.isFollow = isFollow
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isFollow
    }
}

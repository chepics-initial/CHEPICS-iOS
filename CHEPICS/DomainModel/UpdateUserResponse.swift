//
//  UpdateUserResponse.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/06/05.
//

import Foundation

struct UpdateUserResponse: Decodable {
    let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

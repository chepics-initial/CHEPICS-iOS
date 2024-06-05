//
//  Like.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/06/03.
//

import Foundation

struct LikeBody: Encodable {
    let setId: String
    let commentId: String
    
    init(setId: String, commentId: String) {
        self.setId = setId
        self.commentId = commentId
    }
    
    enum CodingKeys: String, CodingKey {
        case setId = "set_id"
        case commentId = "comment_id"
    }
}

struct LikeResponse: Decodable {
    let commentId: String
    let isLiked: Bool
    let count: Int
    
    init(commentId: String, isLiked: Bool, count: Int) {
        self.commentId = commentId
        self.isLiked = isLiked
        self.count = count
    }
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case isLiked = "has_user_like_comment"
        case count = "comment_like_count"
    }
}

//
//  CreateCommentResponse.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/06/14.
//

import Foundation

struct CreateCommentResponse: Decodable {
    let commentId: String
    
    init(commentId: String) {
        self.commentId = commentId
    }
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
    }
}

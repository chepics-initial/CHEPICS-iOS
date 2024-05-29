//
//  CommentImage.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/06.
//

import Foundation

struct CommentImage: Decodable {
    let commentId: String?
    let number: Int
    let url: String
    
    init(commentId: String?, number: Int, url: String) {
        self.commentId = commentId
        self.number = number
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case number = "seq_no"
        case url = "image_url"
    }
}

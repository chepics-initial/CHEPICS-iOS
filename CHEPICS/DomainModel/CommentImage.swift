//
//  CommentImage.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/06.
//

import Foundation

struct CommentImage: Decodable {
    let id: String?
    let commentId: String?
    let url: String
    
    init(id: String?, commentId: String?, url: String) {
        self.id = id
        self.commentId = commentId
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "comment_image_id"
        case commentId
        case url = "image_url"
    }
}

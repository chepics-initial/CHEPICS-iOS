//
//  Comment.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/06.
//

import Foundation

struct Comment: Decodable, Identifiable {
    let id: String
    let parentId: String
    let topicId: String
    let setId: String
    let comment: String
    let link: String?
    let images: [CommentImage]?
    let votes: Int
    let user: User
    let registerTime: Date
    let updateTime: Date
    
    init(id: String, parentId: String, topicId: String, setId: String, comment: String, link: String?, images: [CommentImage]?, votes: Int, user: User, registerTime: Date, updateTime: Date) {
        self.id = id
        self.parentId = parentId
        self.topicId = topicId
        self.setId = setId
        self.comment = comment
        self.link = link
        self.images = images
        self.votes = votes
        self.user = user
        self.registerTime = registerTime
        self.updateTime = updateTime
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "comment_id"
        case parentId
        case topicId
        case setId
        case comment
        case link = "comment_link"
        case images = "comment_image"
        case votes = "comment_like_count"
        case user = "create_user"
        case registerTime
        case updateTime
    }
}

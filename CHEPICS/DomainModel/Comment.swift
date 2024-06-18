//
//  Comment.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/06.
//

import Foundation

struct Comment: Decodable, Identifiable {
    let id: String
    let parentId: String?
    let topicId: String
    let setId: String
    let topic: String
    let comment: String
    let link: String?
    let images: [CommentImage]?
    var votes: Int
    var isLiked: Bool
    let user: User
    let replyCount: Int?
    let replyFor: [User]?
    let registerTime: Date
    
    init(
        id: String,
        parentId: String?,
        topicId: String,
        setId: String,
        topic: String,
        comment: String,
        link: String?,
        images: [CommentImage]?,
        votes: Int,
        isLiked: Bool,
        user: User,
        replyCount: Int?,
        replyFor: [User]?,
        registerTime: Date
    ) {
        self.id = id
        self.parentId = parentId
        self.topicId = topicId
        self.setId = setId
        self.topic = topic
        self.comment = comment
        self.link = link
        self.images = images
        self.votes = votes
        self.isLiked = isLiked
        self.user = user
        self.replyCount = replyCount
        self.replyFor = replyFor
        self.registerTime = registerTime
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "comment_id"
        case parentId = "parent_id"
        case topicId = "topic_id"
        case setId = "set_id"
        case topic = "topic_name"
        case comment
        case link = "comment_link"
        case images = "comment_images"
        case votes = "comment_like_count"
        case isLiked = "has_user_liked_comment"
        case user = "create_user"
        case replyCount = "comment_reply_count"
        case replyFor = "to_users"
        case registerTime = "register_time"
    }
}

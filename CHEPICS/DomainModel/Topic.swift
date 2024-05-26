//
//  Topic.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

struct Topic: Decodable, Identifiable {
    let id: String
    let title: String
    let link: String?
    let description: String?
    let images: [TopicImage]?
    let user: User
    let votes: Int
    let set: [PickSet]?
    let registerTime: Date
    
    init(id: String, title: String, link: String?, description: String?, images: [TopicImage]?, user: User, votes: Int, set: [PickSet]?, registerTime: Date) {
        self.id = id
        self.title = title
        self.link = link
        self.description = description
        self.images = images
        self.user = user
        self.votes = votes
        self.set = set
        self.registerTime = registerTime
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "topic_id"
        case title = "topic_name"
        case link = "topic_link"
        case description = "topic_description"
        case images = "topic_images"
        case user = "create_user"
        case votes = "user_pick_count"
        case set
        case registerTime = "register_time"
    }
}

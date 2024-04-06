//
//  TopicImage.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

struct TopicImage: Decodable {
    let id: String?
    let topicId: String?
    let url: String
    
    init(id: String?, topicId: String?, url: String) {
        self.id = id
        self.topicId = topicId
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "topic_image_id"
        case topicId
        case url = "image_url"
    }
}

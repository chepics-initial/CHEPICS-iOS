//
//  TopicImage.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

struct TopicImage: Decodable {
    let topicId: String?
    let number: Int
    let url: String
    
    init(topicId: String?, number: Int, url: String) {
        self.topicId = topicId
        self.number = number
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case topicId = "topic_id"
        case number = "seq_no"
        case url = "image_url"
    }
}

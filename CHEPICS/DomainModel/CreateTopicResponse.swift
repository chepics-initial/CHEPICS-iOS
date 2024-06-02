//
//  CreateTopicResponse.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/06/01.
//

import Foundation

struct CreateTopicResponse: Decodable {
    let topicId: String
    
    init(topicId: String) {
        self.topicId = topicId
    }
    
    enum CodingKeys: String, CodingKey {
        case topicId = "topic_id"
    }
}

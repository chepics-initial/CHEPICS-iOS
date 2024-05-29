//
//  CreateSet.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/19.
//

import Foundation

struct CreateSetBody: Encodable {
    let topicId: String
    let setText: String
    
    init(topicId: String, setText: String) {
        self.topicId = topicId
        self.setText = setText
    }
    
    enum CodingKeys: String, CodingKey {
        case topicId = "topic_id"
        case setText = "set_name"
    }
}

struct CreateSetResponse: Decodable {
    let setId: String
    
    init(setId: String) {
        self.setId = setId
    }
    
    enum CodingKeys: String, CodingKey {
        case setId = "set_id"
    }
}

//
//  CreateSetBody.swift
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
        case topicId
        case setText = "set_name"
    }
}

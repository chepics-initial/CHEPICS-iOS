//
//  PickSetBody.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/19.
//

import Foundation

struct PickSetBody: Encodable {
    let topicId: String
    let setId: String
    
    init(topicId: String, setId: String) {
        self.topicId = topicId
        self.setId = setId
    }
}

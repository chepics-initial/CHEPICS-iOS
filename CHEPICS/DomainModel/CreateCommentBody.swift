//
//  CreateCommentBody.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/18.
//

import Foundation

struct CreateCommentBody: Encodable {
    let parentId: String?
    let topicId: String
    let setId: String
    let comment: String
    let commentLink: String?
    
}

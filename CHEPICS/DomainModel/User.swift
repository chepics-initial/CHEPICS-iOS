//
//  User.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

struct User: Decodable {
    let id: String
    let username: String
    let fullname: String
    let profileImageUrl: String?
    
    init(id: String, username: String, fullname: String, profileImageUrl: String?) {
        self.id = id
        self.username = username
        self.fullname = fullname
        self.profileImageUrl = profileImageUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case username = "user_name"
        case fullname = "display_name"
        case profileImageUrl = "user_image_url"
    }
}

//
//  User.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

struct User: Decodable, Identifiable {
    let id: String
    let email: String
    let username: String
    let fullname: String
    let bio: String?
    let profileImageUrl: String?
    let registerTime: Date
    let updateTime: Date
    
    init(id: String, email: String, username: String, fullname: String, bio: String?, profileImageUrl: String?, registerTime: Date, updateTime: Date) {
        self.id = id
        self.email = email
        self.username = username
        self.fullname = fullname
        self.bio = bio
        self.profileImageUrl = profileImageUrl
        self.registerTime = registerTime
        self.updateTime = updateTime
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case username = "user_name"
        case fullname = "display_name"
        case profileImageUrl = "user_image_url"
        case email, bio, registerTime, updateTime
    }
}

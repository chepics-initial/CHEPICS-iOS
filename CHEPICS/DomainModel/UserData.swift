//
//  UserData.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/06/04.
//

import Foundation

struct UserData: Codable {
    let username: String
    let fullname: String
    let bio: String?
    let profileImageUrl: String?
    
    init(username: String, fullname: String, bio: String?, profileImageUrl: String?) {
        self.username = username
        self.fullname = fullname
        self.bio = bio
        self.profileImageUrl = profileImageUrl
    }
}

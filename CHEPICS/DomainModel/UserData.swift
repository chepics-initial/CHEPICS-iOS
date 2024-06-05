//
//  UserData.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/06/04.
//

import Foundation

struct UserData {
    let username: String
    let fullname: String
    let bio: String?
    
    init(username: String, fullname: String, bio: String?) {
        self.username = username
        self.fullname = fullname
        self.bio = bio
    }
}

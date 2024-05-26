//
//  User.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

struct User: Decodable, Identifiable {
    let id: String
    let email: String?
    let username: String
    let fullname: String
    let bio: String?
    let profileImageUrl: String?
    let following: Int?
    let followers: Int?
    let isFollowing: Bool?
    let isFollowed: Bool?
    
    init(
        id: String,
        email: String,
        username: String,
        fullname: String,
        bio: String?,
        profileImageUrl: String?,
        following: Int?,
        followers: Int?,
        isFollowing: Bool?,
        isFollowed: Bool?
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.fullname = fullname
        self.bio = bio
        self.profileImageUrl = profileImageUrl
        self.following = following
        self.followers = followers
        self.isFollowing = isFollowing
        self.isFollowed = isFollowed
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case username = "user_name"
        case fullname = "display_name"
        case profileImageUrl = "user_image_url"
        case following = "following_user_count"
        case followers = "followed_user_count"
        case isFollowing = "is_following"
        case isFollowed = "is_followed"
        case email, bio
    }
}

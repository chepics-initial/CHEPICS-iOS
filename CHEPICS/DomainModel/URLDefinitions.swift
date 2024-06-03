//
//  URLDefinitions.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation

enum ServerDirection: String {
    case production = "https://chepics.com/v1/chepics"
    
    var domain: String {
        rawValue
    }
    
    public func urlString(for api: ServerAPI) -> String {
        domain + api.rawValue
    }
}

enum ServerAPI: String {
    case createCode = "/auth/email-confirm-code"
    case checkCode = "/auth/email-confirm-code/check"
    case createUser = "/auth/user"
    case createRefreshToken = "/auth/token/refresh"
    case login = "/auth/login"
    case user = "/user"
    case updateUser = "/user/update"
    case userTopics = "/user/topics"
    case userComments = "/user/comments"
    case topics = "/topics/recommended"
    case followingUsersComments = "/users/following/comments"
    case topic = "/topic"
    case setComments = "/set/comments"
    case topicSets = "/topic/sets"
    case set = "/set"
    case pickSet = "/pick/set"
    case comment = "/comment"
    case replies = "/comments/children"
}

//
//  UserStoreDataSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/03.
//

import Foundation

protocol UserStoreDataSource {
    func getUserId() -> String
    func storeUserId(userId: String)
    func storeUserData(data: UserData)
    func getUserData() -> UserData?
}

//
//  UserStoreLocalSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/03.
//

import Foundation

final class UserStoreLocalSource: UserStoreDataSource {
    static let shared = UserStoreLocalSource()
    
    private init() {}
    
    func getUserId() -> String {
        UserDefaults.standard.userId ?? ""
    }
    
    func storeUserId(userId: String) {
        UserDefaults.standard.userId = userId
    }
}

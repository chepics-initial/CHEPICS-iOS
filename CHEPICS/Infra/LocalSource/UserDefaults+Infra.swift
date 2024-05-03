//
//  UserDefaults+Infra.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation

extension UserDefaults {
    var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: #function)
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    var userId: String? {
        get {
            UserDefaults.standard.string(forKey: #function)
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
}

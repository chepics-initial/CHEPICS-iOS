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
    
    var userData: UserData? {
        get {
            UserDefaults.standard.getCodable(forKey: #function)
        }
        
        set {
            UserDefaults.standard.setCodable(newValue, forKey: #function)
        }
    }
}

extension UserDefaults {
    func setCodable(_ value: some Codable, forKey key: String) {
        if let serializedData = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(serializedData, forKey: key)
        }
    }

    func getCodable<T: Codable>(forKey key: String) -> T? {
        guard let serializedData = UserDefaults.standard.object(forKey: key) as? Data,
              let value = try? JSONDecoder().decode(T.self, from: serializedData)
        else {
            return nil
        }
        return value
    }
}

//
//  KeychainAccess.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/13.
//

import Foundation
import KeychainAccess

var keychain: Keychain {
    let identifier = Bundle.main.bundleIdentifier ?? ""
    return Keychain(service: identifier)
}

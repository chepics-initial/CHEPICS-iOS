//
//  TokenDataSource.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/04/13.
//

import Foundation

protocol TokenDataSource {
    func storeToken(accessToken: String, refreshToken: String)
}

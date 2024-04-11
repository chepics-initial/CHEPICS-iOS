//
//  API.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation

enum API {    
    static func getHeaders() -> [String: String] {
        var headers = [String: String]()
        if let accessToken = UserDefaults.standard.accessToken {
            headers[RequestHeaderKeys.bffAuthToken.rawValue] = accessToken
        }
        return headers
    }
}

//
//  URLDefinitions.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation

enum ServerDirection: String {
    case production = "https://chepics.com"
    
    var domain: String {
        rawValue
    }

    public func urlString(for api: ServerAPI) -> String {
        domain + api.rawValue
    }
}

enum ServerAPI: String {
    case createCode = "/v1/chepics/auth/email-confirm-code"
    case checkCode = "/v1/chepics/auth/email-confirm-code/check"
}

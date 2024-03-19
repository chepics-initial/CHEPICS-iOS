//
//  RequestHeader.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/18.
//

import Foundation

final class RequestHeader: RequestHeaderDataSource {
    static let shared = RequestHeader()
    
    private var headers = [String: String]()
    
    private init() {}
    
    func updateHeader(key: RequestHeaderKeys, value: String) {
        headers[key.rawValue] = value
    }
}

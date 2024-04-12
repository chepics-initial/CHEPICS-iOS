//
//  ErrorResponse.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation

struct ErrorResponse: Decodable {
    let statusCode: String
    let message: String
    let errorCode: String
    
    init(statusCode: String, message: String, errorCode: String) {
        self.statusCode = statusCode
        self.message = message
        self.errorCode = errorCode
    }
}

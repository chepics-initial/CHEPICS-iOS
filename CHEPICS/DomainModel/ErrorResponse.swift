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
    let errorCode: ErrorCode
    
    init(statusCode: String, message: String, errorCode: ErrorCode) {
        self.statusCode = statusCode
        self.message = message
        self.errorCode = errorCode
    }
    
    enum ErrorCode: Decodable {
        case USED_EMAIL
        case CODE_INCORRECT_OR_EXPIRED
        case NOT_CONFIRMED_EMAIL
        case EMAIL_OR_PASSWORD_INCORRECT
        case INVALID_ACCESS_TOKEN
        case RESOURCE_NOT_FOUND
        case INTERNAL_SERVER_ERROR
    }
}

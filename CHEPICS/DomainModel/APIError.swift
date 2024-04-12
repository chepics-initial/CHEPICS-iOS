//
//  APIError.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import Foundation

// TODO: - エラーの詳細が決まり次第修正必須
enum APIError: Error, Equatable {
    case decodingError(any Error)
    case networkError(any Error)
    case invalidStatus(Int)
    case errorResponse(ErrorResponse, Int)
    case otherError

    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingError, .decodingError), (.errorResponse, .errorResponse),
             (.invalidStatus, .invalidStatus), (.networkError, .networkError), (.otherError, .otherError):
            true
        default:
            false
        }
    }
}

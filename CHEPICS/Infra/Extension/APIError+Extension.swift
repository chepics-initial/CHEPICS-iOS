//
//  APIError+Extension.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation
import Alamofire

// TODO: - 確認事項が決まり次第修正必須
extension APIError {
    init(_ afError: AFError) {
        switch afError {
        case .responseSerializationFailed(reason: let reason):
            switch reason {
            case .decodingFailed(error: let error):
                self = .decodingError(error)
            default:
                self = .otherError
            }
        case .sessionTaskFailed(error: let error):
            self = .networkError(error)
        case .responseValidationFailed(reason: let reason):
            switch reason {
            case .unacceptableStatusCode(code: let code):
                self = .invalidStatus(code)
            case .customValidationFailed(error: let error):
                if let apiError = error as? APIError {
                    self = apiError
                } else {
                    self = .otherError
                }
            default:
                self = .otherError
            }
        default:
            self = .otherError
        }
    }
}

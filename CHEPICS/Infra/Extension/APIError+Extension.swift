//
//  APIError+Extension.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation
import Alamofire

extension APIError {
    init(statusCode: Int?, _ afError: AFError) {
        switch afError {
        case .responseSerializationFailed(reason: let reason):
            switch reason {
            case .decodingFailed(error: let error):
                self = .decodingError(nil, error)
            case .invalidEmptyResponse(type: _):
                self = .decodingError(statusCode, nil)
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

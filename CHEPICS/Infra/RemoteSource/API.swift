//
//  API.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/11.
//

import Foundation
import Alamofire

enum API {
    private static let decoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    private static let encoder = {
        let encoder = JSONEncoder()
        return encoder
    }()
    
    static let parameterEncoding = URLEncoding(
        destination: .queryString,
        arrayEncoding: .brackets,
        boolEncoding: .literal
    )
    
    // TODO: - 確認事項が決まり次第修正必須
    private static func makeValidation() -> DataRequest.Validation {
        { _, response, data in
            guard let data,
                  let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) else {
                return .success(())
            }
            return .failure(APIError.errorResponse(errorResponse, response.statusCode))
        }
    }
    
    static func request<T: Decodable>(
        _ baseURLString: String,
        responseType: T.Type,
        queryParameters: [String: Any]?
    ) async -> Result<T, APIError> {
        let headers = getHeaders()
        switch await AF.request(
            baseURLString,
            method: .get,
            parameters: queryParameters,
            encoding: parameterEncoding,
            headers: HTTPHeaders(headers)
        )
        .handleRequest(
            responseType: responseType,
            decoder: decoder,
            validation: makeValidation()
        ) {
        case .success(let response):
            return .success(response)
        case .failure(let firstError):
            switch firstError {
            case .decodingError, .networkError, .invalidStatus, .otherError:
                return .failure(firstError)
            case .errorResponse(let errorResponse, _):
                switch errorResponse.errorCode {
                case .USED_EMAIL, .CODE_INCORRECT_OR_EXPIRED, .NOT_CONFIRMED_EMAIL, .EMAIL_OR_PASSWORD_INCORRECT, .RESOURCE_NOT_FOUND, .INTERNAL_SERVER_ERROR:
                    return .failure(firstError)
                case .INVALID_ACCESS_TOKEN:
                    guard baseURLString != ServerDirection.production.urlString(for: .createRefreshToken),
                          let refreshToken = TokenStore.getRefreshToken() else { return .failure(firstError) }
                    switch await API.postRequest(
                        ServerDirection.production.urlString(for: .createRefreshToken),
                        responseType: AuthResponse.self,
                        httpBody: refreshToken
                    ) {
                    case .success(let response):
                        TokenStore.storeToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
                        
                        return await request(baseURLString, responseType: responseType, queryParameters: queryParameters)
                    case .failure(let secondError):
                        return .failure(secondError)
                    }
                }
            }
        }
    }
    
    static func postRequest<T: Decodable>(
        _ baseURLString: String,
        responseType: T.Type,
        httpBody: some Encodable
    ) async -> Result<T, APIError> {
        let headers = getHeaders()
        switch await AF.request(
            baseURLString,
            method: .post,
            parameters: httpBody,
            encoder: JSONParameterEncoder(encoder: encoder),
            headers: HTTPHeaders(headers)
        )
        .handleRequest(
            responseType: responseType,
            decoder: decoder,
            validation: makeValidation()
        ) {
        case .success(let response):
            return .success(response)
        case .failure(let firstError):
            switch firstError {
            case .decodingError, .networkError, .invalidStatus, .otherError:
                return .failure(firstError)
            case .errorResponse(let errorResponse, _):
                switch errorResponse.errorCode {
                case .USED_EMAIL, .CODE_INCORRECT_OR_EXPIRED, .NOT_CONFIRMED_EMAIL, .EMAIL_OR_PASSWORD_INCORRECT, .RESOURCE_NOT_FOUND, .INTERNAL_SERVER_ERROR:
                    return .failure(firstError)
                case .INVALID_ACCESS_TOKEN:
                    guard baseURLString != ServerDirection.production.urlString(for: .createRefreshToken),
                          let refreshToken = TokenStore.getRefreshToken() else { return .failure(firstError) }
                    switch await API.postRequest(
                        ServerDirection.production.urlString(for: .createRefreshToken),
                        responseType: AuthResponse.self,
                        httpBody: refreshToken
                    ) {
                    case .success(let response):
                        TokenStore.storeToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
                        
                        return await postRequest(baseURLString, responseType: responseType, httpBody: httpBody)
                    case .failure(let secondError):
                        switch secondError {
                        case .decodingError, .networkError, .invalidStatus, .otherError:
                            return .failure(secondError)
                        case .errorResponse(let errorResponse, _):
                            switch errorResponse.errorCode {
                            case .USED_EMAIL, .CODE_INCORRECT_OR_EXPIRED, .NOT_CONFIRMED_EMAIL, .EMAIL_OR_PASSWORD_INCORRECT, .RESOURCE_NOT_FOUND, .INTERNAL_SERVER_ERROR:
                                return .failure(secondError)
                            case .INVALID_ACCESS_TOKEN:
                                // TODO: - refreshTokenが切れていた時の対処
                                fatalError()
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func getHeaders() -> [String: String] {
        var headers = [String: String]()
        if let accessToken = UserDefaults.standard.accessToken {
            headers[RequestHeaderKeys.bffAuthToken.rawValue] = accessToken
        }
        return headers
    }
}

private extension DataRequest {
    // TODO: - 確認事項が決まり次第修正必須
    func handleRequest<T: Decodable>(
        responseType: T.Type,
        decoder: JSONDecoder,
        validation: @escaping Validation
    ) async -> Result<T, APIError> {
        validate(validation)
        await handleResponseHeader(asyncResponse())
        validate(statusCode: 200 ..< 300)
        return await serializingDecodable(responseType, decoder: decoder, emptyResponseCodes: [200, 204, 205])
            .result
            .mapError { afError in
                APIError(afError)
            }
    }
    
    func asyncResponse() async -> AFDataResponse<Data?> {
        await withCheckedContinuation { continuation in
            response(completionHandler: { response in
                #if DEBUG
                debugPrint(response)
                #endif
                continuation.resume(returning: response)
            })
        }
    }

    func handleResponseHeader(_ response: AFDataResponse<Data?>) {
        guard let headers = response.response?.headers.dictionary,
              let url = URL(string: "https://chepics.com/") else {
            return
        }
        for cookie in HTTPCookie.cookies(withResponseHeaderFields: headers, for: url) {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }
}

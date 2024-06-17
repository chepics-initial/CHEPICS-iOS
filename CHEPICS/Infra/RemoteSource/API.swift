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
        decoder.dateDecodingStrategy = .iso8601
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
                case .USED_EMAIL,
                        .CODE_INCORRECT_OR_EXPIRED,
                        .NOT_CONFIRMED_EMAIL,
                        .EMAIL_OR_PASSWORD_INCORRECT,
                        .RESOURCE_NOT_FOUND,
                        .INVALID_REFRESH_TOKEN,
                        .INTERNAL_SERVER_ERROR,
                        .ERROR_SET_NOT_PICKED,
                        .ERROR_TOPIC_NOT_PICKED:
                    return .failure(firstError)
                case .INVALID_ACCESS_TOKEN:
                    guard baseURLString != ServerDirection.production.urlString(for: .createRefreshToken),
                          let refreshToken = TokenStore.getRefreshToken() else { return .failure(firstError) }
                    switch await API.postRequest(
                        ServerDirection.production.urlString(for: .createRefreshToken),
                        responseType: AuthResponse.self,
                        httpBody: TokenRefreshBody(refreshToken: refreshToken)
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
                case .USED_EMAIL,
                        .CODE_INCORRECT_OR_EXPIRED,
                        .NOT_CONFIRMED_EMAIL,
                        .EMAIL_OR_PASSWORD_INCORRECT,
                        .RESOURCE_NOT_FOUND,
                        .INVALID_REFRESH_TOKEN,
                        .INTERNAL_SERVER_ERROR,
                        .ERROR_SET_NOT_PICKED,
                        .ERROR_TOPIC_NOT_PICKED:
                    return .failure(firstError)
                case .INVALID_ACCESS_TOKEN:
                    guard baseURLString != ServerDirection.production.urlString(for: .createRefreshToken),
                          let refreshToken = TokenStore.getRefreshToken() else { return .failure(firstError) }
                    switch await API.postRequest(
                        ServerDirection.production.urlString(for: .createRefreshToken),
                        responseType: AuthResponse.self,
                        httpBody: TokenRefreshBody(refreshToken: refreshToken)
                    ) {
                    case .success(let response):
                        TokenStore.storeToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
                        
                        return await postRequest(baseURLString, responseType: responseType, httpBody: httpBody)
                    case .failure(let secondError):
                        return .failure(secondError)
                    }
                }
            }
        }
    }
    
    static func updateUser<T: Decodable>(
        username: String,
        fullname: String,
        bio: String?,
        image: Data?,
        _ baseURLString: String,
        responseType: T.Type
    ) async -> Result<T, APIError> {
        let headers = getHeaders()
        switch await AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(username.data(using: .utf8)!, withName: "user_name")
            multipartFormData.append(fullname.data(using: .utf8)!, withName: "display_name")
            if let bio {
                multipartFormData.append(bio.data(using: .utf8)!, withName: "bio")
            }
            if let image {
                multipartFormData.append(image, withName: "user_image", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            let isUpdated = image != nil ? "true" : "false"
            multipartFormData.append(Data(isUpdated.utf8), withName: "is_update_user_image")
        }, to: baseURLString, method: .post, headers: HTTPHeaders(headers))
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
                case .USED_EMAIL,
                        .CODE_INCORRECT_OR_EXPIRED,
                        .NOT_CONFIRMED_EMAIL,
                        .EMAIL_OR_PASSWORD_INCORRECT,
                        .RESOURCE_NOT_FOUND,
                        .INVALID_REFRESH_TOKEN,
                        .INTERNAL_SERVER_ERROR,
                        .ERROR_SET_NOT_PICKED,
                        .ERROR_TOPIC_NOT_PICKED:
                    return .failure(firstError)
                case .INVALID_ACCESS_TOKEN:
                    guard baseURLString != ServerDirection.production.urlString(for: .createRefreshToken),
                          let refreshToken = TokenStore.getRefreshToken() else { return .failure(firstError) }
                    switch await API.postRequest(
                        ServerDirection.production.urlString(for: .createRefreshToken),
                        responseType: AuthResponse.self,
                        httpBody: TokenRefreshBody(refreshToken: refreshToken)
                    ) {
                    case .success(let response):
                        TokenStore.storeToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
                        
                        return await updateUser(
                            username: username,
                            fullname: fullname,
                            bio: bio,
                            image: image,
                            baseURLString,
                            responseType: responseType
                        )
                    case .failure(let secondError):
                        return .failure(secondError)
                    }
                }
            }
        }
    }
    
    static func createTopic<T: Decodable>(
        title: String,
        link: String?,
        description: String?,
        images: [Data]?,
        _ baseURLString: String,
        responseType: T.Type
    ) async -> Result<T, APIError> {
        let headers = getHeaders()
        switch await AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(title.data(using: .utf8)!, withName: "topic_name")
            if let link {
                multipartFormData.append(link.data(using: .utf8)!, withName: "topic_link")
            }
            if let description {
                multipartFormData.append(description.data(using: .utf8)!, withName: "topic_description")
            }
            if let images {
                for (index, image) in images.enumerated() {
                    multipartFormData.append(Data(String(index + 1).utf8), withName: "topic_images[\(index)][seq_no]")
                    multipartFormData.append(image, withName: "topic_images[\(index)][image_file]", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                }
            }
        }, to: baseURLString, method: .post, headers: HTTPHeaders(headers))
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
                case .USED_EMAIL,
                        .CODE_INCORRECT_OR_EXPIRED,
                        .NOT_CONFIRMED_EMAIL,
                        .EMAIL_OR_PASSWORD_INCORRECT,
                        .RESOURCE_NOT_FOUND,
                        .INVALID_REFRESH_TOKEN,
                        .INTERNAL_SERVER_ERROR,
                        .ERROR_SET_NOT_PICKED,
                        .ERROR_TOPIC_NOT_PICKED:
                    return .failure(firstError)
                case .INVALID_ACCESS_TOKEN:
                    guard baseURLString != ServerDirection.production.urlString(for: .createRefreshToken),
                          let refreshToken = TokenStore.getRefreshToken() else { return .failure(firstError) }
                    switch await API.postRequest(
                        ServerDirection.production.urlString(for: .createRefreshToken),
                        responseType: AuthResponse.self,
                        httpBody: TokenRefreshBody(refreshToken: refreshToken)
                    ) {
                    case .success(let response):
                        TokenStore.storeToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
                        
                        return await createTopic(
                            title: title,
                            link: link,
                            description: description,
                            images: images,
                            baseURLString,
                            responseType: responseType
                        )
                    case .failure(let secondError):
                        return .failure(secondError)
                    }
                }
            }
        }
    }
    
    static func createComment<T: Decodable>(
        parentId: String?,
        topicId: String,
        setId: String,
        comment: String,
        link: String?,
        replyFor: [String]?,
        images: [Data]?,
        _ baseURLString: String,
        responseType: T.Type
    ) async -> Result<T, APIError> {
        let headers = getHeaders()
        switch await AF.upload(multipartFormData: { multipartFormData in
            if let parentId {
                multipartFormData.append(parentId.data(using: .utf8)!, withName: "parent_id")
            }
            multipartFormData.append(topicId.data(using: .utf8)!, withName: "topic_id")
            multipartFormData.append(setId.data(using: .utf8)!, withName: "set_id")
            multipartFormData.append(comment.data(using: .utf8)!, withName: "comment")
            if let link {
                multipartFormData.append(link.data(using: .utf8)!, withName: "comment_link")
            }
            if let replyFor {
                for (index, userId) in replyFor.enumerated() {
                    multipartFormData.append(userId.data(using: .utf8)!, withName: "to_user_ids[\(index)]")
                }
            }
            if let images {
                for (index, image) in images.enumerated() {
                    multipartFormData.append(Data(String(index + 1).utf8), withName: "comment_images[\(index)][seq_no]")
                    multipartFormData.append(image, withName: "comment_images[\(index)][image_file]", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                }
            }
        }, to: baseURLString, method: .post, headers: HTTPHeaders(headers))
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
                case .USED_EMAIL,
                        .CODE_INCORRECT_OR_EXPIRED,
                        .NOT_CONFIRMED_EMAIL,
                        .EMAIL_OR_PASSWORD_INCORRECT,
                        .RESOURCE_NOT_FOUND,
                        .INVALID_REFRESH_TOKEN,
                        .INTERNAL_SERVER_ERROR,
                        .ERROR_SET_NOT_PICKED,
                        .ERROR_TOPIC_NOT_PICKED:
                    return .failure(firstError)
                case .INVALID_ACCESS_TOKEN:
                    guard baseURLString != ServerDirection.production.urlString(for: .createRefreshToken),
                          let refreshToken = TokenStore.getRefreshToken() else { return .failure(firstError) }
                    switch await API.postRequest(
                        ServerDirection.production.urlString(for: .createRefreshToken),
                        responseType: AuthResponse.self,
                        httpBody: TokenRefreshBody(refreshToken: refreshToken)
                    ) {
                    case .success(let response):
                        TokenStore.storeToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
                        
                        return await createComment(
                            parentId: parentId,
                            topicId: topicId,
                            setId: setId,
                            comment: comment,
                            link: link,
                            replyFor: replyFor,
                            images: images,
                            baseURLString,
                            responseType: responseType
                        )
                    case .failure(let secondError):
                        return .failure(secondError)
                    }
                }
            }
        }
    }
    
    static func getHeaders() -> [String: String] {
        var headers = [String: String]()
        if let accessToken = UserDefaults.standard.accessToken {
            headers[RequestHeaderKeys.bffAuthToken.rawValue] = "Bearer \(accessToken)"
        }
        return headers
    }
}

private extension DataRequest {
    func handleRequest<T: Decodable>(
        responseType: T.Type,
        decoder: JSONDecoder,
        validation: @escaping Validation
    ) async -> Result<T, APIError> {
        validate(validation)
        let response = await asyncResponse()
        handleResponseHeader(response)
        validate(statusCode: 200 ..< 300)
        return await serializingDecodable(responseType, decoder: decoder, emptyResponseCodes: [200, 204, 205])
            .result
            .mapError { afError in
                APIError(statusCode: response.response?.statusCode, afError)
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

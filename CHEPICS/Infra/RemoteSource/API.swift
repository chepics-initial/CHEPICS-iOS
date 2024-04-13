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
            debugPrint(response)
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
        return await AF.request(
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
        )
    }

    static func postRequest<T: Decodable>(
        _ baseURLString: String,
        responseType: T.Type,
        httpBody: some Encodable
    ) async -> Result<T, APIError> {
        let headers = getHeaders()
        return await AF.request(
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
        )
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
        validate(statusCode: 200 ..< 300)
        return await serializingDecodable(responseType, decoder: decoder, emptyResponseCodes: [200, 204, 205])
            .result
            .mapError { afError in
                APIError(afError)
            }
    }
}

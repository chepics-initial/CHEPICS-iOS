//
//  RequestHeaderRepository.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/18.
//

import Foundation

protocol RequestHeaderRepository {
    func updateHeader(key: RequestHeaderKeys, value: String)
}

final class RequestHeaderRepositoryImpl: RequestHeaderRepository {
    private let requestHeaderDataSource: any RequestHeaderDataSource
    
    init(requestHeaderDataSource: some RequestHeaderDataSource) {
        self.requestHeaderDataSource = requestHeaderDataSource
    }
    
    func updateHeader(key: RequestHeaderKeys, value: String) {
        requestHeaderDataSource.updateHeader(key: key, value: value)
    }
}

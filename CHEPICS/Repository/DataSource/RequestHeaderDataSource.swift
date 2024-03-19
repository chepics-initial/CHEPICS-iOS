//
//  RequestHeaderDataSource.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/18.
//

import Foundation

protocol RequestHeaderDataSource {
    func updateHeader(key: RequestHeaderKeys, value: String)
}

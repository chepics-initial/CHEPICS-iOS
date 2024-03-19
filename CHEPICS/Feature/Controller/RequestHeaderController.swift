//
//  RequestHeaderController.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/18.
//

import Foundation

final class RequestHeaderController {
    private let requestHeaderUseCase: any RequestHeaderUseCase

    init(requestHeaderUseCase: some RequestHeaderUseCase) {
        self.requestHeaderUseCase = requestHeaderUseCase
    }

    func setUp() {
        requestHeaderUseCase.setUp()
    }
}

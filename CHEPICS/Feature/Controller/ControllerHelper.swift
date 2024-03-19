//
//  ControllerHelper.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/18.
//

import Foundation

final class ControllerHelper {
    private let requestHeaderController: RequestHeaderController
    
    init(requestHeaderController: RequestHeaderController) {
        self.requestHeaderController = requestHeaderController
    }
    
    func setUp() {
        requestHeaderController.setUp()
    }
}

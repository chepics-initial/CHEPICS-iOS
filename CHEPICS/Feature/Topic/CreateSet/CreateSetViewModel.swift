//
//  CreateSetViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/15.
//

import Foundation

@MainActor final class CreateSetViewModel: ObservableObject {
    @Published var setText = ""
    var isActive: Bool {
        return true
    }
    let topicId: String
    
    init(topicId: String) {
        self.topicId = topicId
    }
}

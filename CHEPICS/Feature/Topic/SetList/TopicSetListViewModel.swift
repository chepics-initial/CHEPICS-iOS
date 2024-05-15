//
//  TopicSetListViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/15.
//

import Foundation

@MainActor final class TopicSetListViewModel: ObservableObject {
    @Published private(set) var set: PickSet?
    var isActive: Bool {
        if set != nil {
            return true
        }
        return false
    }
    let topicId: String
    
    init(topicId: String) {
        self.topicId = topicId
    }
}

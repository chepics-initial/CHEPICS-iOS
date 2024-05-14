//
//  TopicTopViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/14.
//

import Foundation

@MainActor final class TopicTopViewModel: ObservableObject {
    @Published private(set) var topic: Topic
    
    init(topic: Topic) {
        self.topic = topic
    }
}

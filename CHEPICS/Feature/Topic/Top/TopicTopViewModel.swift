//
//  TopicTopViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/14.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor final class TopicTopViewModel: ObservableObject {
    @Published private(set) var topic: Topic
    @Published private(set) var viewStatus: TopicViewStatus = .top
    @Published private(set) var selectedSet: PickSet?
    @Published private(set) var uiState: UIState = .loading
    @Published private(set) var comments: [Comment]?
    
    private let topicTopUseCase: any TopicTopUseCase
    
    init(topic: Topic, topicTopUseCase: some TopicTopUseCase) {
        self.topic = topic
        self.topicTopUseCase = topicTopUseCase
    }
    
    func onAppear() async {
        await fetchTopic()
    }
    
    private func fetchTopic() async {
        switch await topicTopUseCase.fetchTopic(topicId: topic.id) {
        case .success(let topic):
            self.topic = topic
        case .failure:
            return
        }
    }
    
    func selectSet(set: PickSet) async {
        selectedSet = set
        viewStatus = .detail
        await fetchTopic()
        uiState = .loading
        switch await topicTopUseCase.fetchSetComments(setId: set.id, offset: nil) {
        case .success(let comments):
            self.comments = comments
            uiState = .success
        case .failure:
            uiState = .failure
        }
    }
}

enum TopicViewStatus {
    case top
    case detail
}

final class TopicTopUseCase_Previews: TopicTopUseCase {
    func fetchTopic(topicId: String) async -> Result<Topic, APIError> {
        .success(mockTopic1)
    }
    
    func fetchSetComments(setId: String, offset: Int?) async -> Result<[Comment], APIError> {
        .success([mockComment1])
    }
}

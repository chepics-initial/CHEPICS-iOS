//
//  TopicTopViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/14.
//

import Foundation

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
        switch await topicTopUseCase.fetchTopic(topicId: topic.id) {
        case .success(let topic):
            self.topic = topic
        case .failure:
            return
        }
    }
    
    func selectSet(set: PickSet) async {
        selectedSet = set
        uiState = .loading
        switch await topicTopUseCase.fetchSetComments(setId: set.id) {
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
    
    func fetchSetComments(setId: String) async -> Result<[Comment], APIError> {
        .success([mockComment1])
    }
}

//
//  TopicSetListViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/15.
//

import Foundation

@MainActor final class TopicSetListViewModel: ObservableObject {
    @Published private(set) var selectedSet: PickSet?
    @Published private(set) var uiState: UIState = .loading
    @Published private(set) var sets: [PickSet]?
    
    private let topicSetListUseCase: any TopicSetListUseCase
    
    var isActive: Bool {
        if selectedSet != nil {
            return true
        }
        return false
    }
    let topicId: String
    
    init(topicId: String, topicSetListUseCase: some TopicSetListUseCase) {
        self.topicId = topicId
        self.topicSetListUseCase = topicSetListUseCase
    }
    
    func onAppear() async {
        switch await topicSetListUseCase.fetchSets(topicId: topicId) {
        case .success(let sets):
            self.sets = sets
            uiState = .success
        case .failure:
            uiState = .failure
        }
    }
}

final class TopicSetListUseCase_Previews: TopicSetListUseCase {
    func fetchSets(topicId: String) async -> Result<[PickSet], APIError> {
        .success([])
    }
}

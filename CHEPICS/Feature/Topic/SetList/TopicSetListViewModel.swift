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
    @Published private(set) var isLoading = false
    @Published private(set) var isCompleted = false
    @Published var showAlert = false
    let currentSet: PickSet?
    private var isFetchFinished = false
    
    private let topicSetListUseCase: any TopicSetListUseCase
    
    var isActive: Bool {
        if selectedSet?.id == currentSet?.id || selectedSet == nil {
            return false
        }
        return true
    }
    let topicId: String
    
    init(topicId: String, currentSet: PickSet?, topicSetListUseCase: some TopicSetListUseCase) {
        self.topicId = topicId
        self.currentSet = currentSet
        self.selectedSet = currentSet
        self.topicSetListUseCase = topicSetListUseCase
    }
    
    func onAppear() async {
        if !isFetchFinished {
            await fetchSets()
        }
    }
    
    func fetchSets() async {
        switch await topicSetListUseCase.fetchSets(topicId: topicId) {
        case .success(let sets):
            self.sets = sets
            uiState = .success
            isFetchFinished = true
        case .failure:
            uiState = .failure
        }
    }
    
    func selectSet(set: PickSet) {
        selectedSet = set
    }
    
    func onTapSelectButton() async {
        guard let selectedSet else { return }
        isLoading = true
        let result = await topicSetListUseCase.pickSet(topicId: topicId, setId: selectedSet.id)
        isLoading = false
        switch result {
        case .success(let set):
            self.selectedSet = set
            isCompleted = true
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_REFRESH_TOKEN {
                return
            }
            showAlert = true
        }
    }
}

final class TopicSetListUseCase_Previews: TopicSetListUseCase {
    func fetchSets(topicId: String) async -> Result<[PickSet], APIError> {
        .success([])
    }
    
    func pickSet(topicId: String, setId: String) async -> Result<PickSet, APIError> {
        .success(mockSet1)
    }
}

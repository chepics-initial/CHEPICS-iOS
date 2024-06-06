//
//  MyPageTopicListViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/06/06.
//

import Foundation

@MainActor
final class MyPageTopicListViewModel: ObservableObject {
    @Published private(set) var uiState: UIState = .loading
    @Published private(set) var sets: [MySet]?
    private var isInitialAppear = true
    
    private let myPageTopicListUseCase: any MyPageTopicListUseCase
    
    init(myPageTopicListUseCase: some MyPageTopicListUseCase) {
        self.myPageTopicListUseCase = myPageTopicListUseCase
    }
    
    func onAppear() async {
        if isInitialAppear || uiState == .failure {
            isInitialAppear = false
            uiState = .loading
            switch await myPageTopicListUseCase.fetchPickedSets(offset: nil) {
            case .success(let sets):
                self.sets = sets
                uiState = .success
            case .failure:
                uiState = .failure
            }
        }
    }
    
    func fetchSets() async {
        switch await myPageTopicListUseCase.fetchPickedSets(offset: nil) {
        case .success(let sets):
            self.sets = sets
            uiState = .success
        case .failure:
            uiState = .failure
        }
    }
}

final class MyPageTopicListUseCase_Previews: MyPageTopicListUseCase {
    func fetchPickedSets(offset: Int?) async -> Result<[MySet], APIError> {
        .success([])
    }
}

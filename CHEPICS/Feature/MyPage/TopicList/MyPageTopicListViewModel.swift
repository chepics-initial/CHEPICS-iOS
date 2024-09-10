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
    @Published private(set) var footerStatus: FooterStatus = .loadingStopped
    private var isInitialAppear = true
    private var offset = 0
    private let myPageTopicListUseCase: any MyPageTopicListUseCase
    
    init(myPageTopicListUseCase: some MyPageTopicListUseCase) {
        self.myPageTopicListUseCase = myPageTopicListUseCase
    }
    
    func onAppear() async {
        if isInitialAppear || uiState == .failure {
            isInitialAppear = false
            uiState = .loading
            await fetchSets()
        }
    }
    
    func fetchSets() async {
        switch await myPageTopicListUseCase.fetchPickedSets(offset: nil) {
        case .success(let sets):
            self.sets = sets
            footerStatus = sets.count < Constants.arrayLimit ? .allFetched : .loadingStopped
            uiState = .success
            offset = Constants.arrayLimit
        case .failure:
            uiState = .failure
        }
    }
    
    func onAppearFooterView() async {
        guard footerStatus == .loadingStopped || footerStatus == .failure else { return }
        footerStatus = .loadingStarted
        switch await myPageTopicListUseCase.fetchPickedSets(offset: offset) {
        case .success(let additionalSets):
            for additionalSet in additionalSets {
                if let index = sets?.firstIndex(where: { $0.set.id == additionalSet.set.id }) {
                    sets?[index] = additionalSet
                } else {
                    sets?.append(additionalSet)
                }
            }
            if additionalSets.count < Constants.arrayLimit {
                footerStatus = .allFetched
                offset = 0
                return
            }
            footerStatus = .loadingStopped
            offset += Constants.arrayLimit
        case .failure:
            footerStatus = .failure
        }
    }
}

final class MyPageTopicListUseCase_Previews: MyPageTopicListUseCase {
    func fetchPickedSets(offset: Int?) async -> Result<[MySet], APIError> {
        .success([])
    }
}

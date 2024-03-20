//
//  FeedViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/19.
//

import Foundation

@MainActor final class FeedViewModel: ObservableObject {
    @Published private(set) var selectedTab: TabType = .topics
    @Published var topics: [Topic]?
    
    private let feedUseCase: any FeedUseCase
    
    init(feedUseCase: some FeedUseCase) {
        self.feedUseCase = feedUseCase
    }
    
    func selectTab(type: TabType) {
        selectedTab = type
    }
    
    func onAppear() async {
        switch await feedUseCase.fetchFavoriteTopics() {
        case .success(let topics):
            self.topics = topics
        case .failure(let failure):
            return
        }
    }
}

enum TabType: CaseIterable {
    case topics
    case comments
    
    var title: String {
        switch self {
        case .topics:
            "おすすめ"
        case .comments:
            "フォロー中"
        }
    }
}

final class FeedUseCase_Previews: FeedUseCase {
    func fetchFavoriteTopics() async -> Result<[Topic], APIError> {
        .success([])
    }
}

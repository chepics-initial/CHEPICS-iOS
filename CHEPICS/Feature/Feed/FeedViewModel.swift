//
//  FeedViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/19.
//

import Foundation

@MainActor final class FeedViewModel: ObservableObject {
    @Published private(set) var selectedTab: FeedTabType = .topics {
        didSet {
            switch selectedTab {
            case .topics:
                if topicUIState != .success {
                    Task { await fetchTopics() }
                }
            case .comments:
                return 
            }
        }
    }
    @Published var topics: [Topic]?
    @Published private(set) var topicUIState: UIState = .loading
    
    private let feedUseCase: any FeedUseCase
    
    init(feedUseCase: some FeedUseCase) {
        self.feedUseCase = feedUseCase
    }
    
    func selectTab(type: FeedTabType) {
        selectedTab = type
    }
    
    func fetchTopics() async {
        if topicUIState != .success {
            topicUIState = .loading
        }
        switch await feedUseCase.fetchFavoriteTopics() {
        case .success(let topics):
            self.topics = topics
            topicUIState = .success
        case .failure:
            topicUIState = .failure
        }
    }
}

enum FeedTabType: CaseIterable {
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

enum UIState {
    case loading
    case success
    case failure
}

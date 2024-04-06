//
//  FeedViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/19.
//

import Foundation

@MainActor final class FeedViewModel: ObservableObject {
    @Published var selectedTab: FeedTabType = .topics {
        didSet {
            switch selectedTab {
            case .topics:
                if topicUIState != .success || !isTopicOnAppearFinished {
                    Task { await fetchTopics() }
                }
            case .comments:
                if commentUIState != .success || !isCommentOnAppearFinished {
                    Task { await fetchComments() }
                }
            }
        }
    }
    @Published private(set) var topics: [Topic]?
    @Published private(set) var comments: [Comment]?
    @Published private(set) var topicUIState: UIState = .loading
    @Published private(set) var commentUIState: UIState = .loading
    private var isTopicOnAppearFinished = false
    private var isCommentOnAppearFinished = false
    
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
        isTopicOnAppearFinished = true
        switch await feedUseCase.fetchFavoriteTopics() {
        case .success(let topics):
            self.topics = topics
            topicUIState = .success
        case .failure:
            topicUIState = .failure
        }
    }
    
    func fetchComments() async {
        if commentUIState != .success {
            commentUIState = .loading
        }
        isCommentOnAppearFinished = true
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        comments = [mockComment1, mockComment2, mockComment3, mockComment4]
        commentUIState = .success
    }
    
    func onDisappear() {
        isTopicOnAppearFinished = false
        isCommentOnAppearFinished = false
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

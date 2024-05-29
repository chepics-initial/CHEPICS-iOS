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
                if !isTopicFetchStarted {
                    Task { await fetchTopics() }
                }
            case .comments:
                if !isCommentFetchStarted {
                    Task { await fetchComments() }
                }
            }
        }
    }
    @Published private(set) var topics: [Topic]?
    @Published private(set) var comments: [Comment]?
    @Published private(set) var topicUIState: UIState = .loading
    @Published private(set) var commentUIState: UIState = .loading
    private var isTopicFetchStarted = false
    private var isCommentFetchStarted = false
    
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
        isTopicFetchStarted = true
        switch await feedUseCase.fetchFavoriteTopics(offset: nil) {
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
        isCommentFetchStarted = true
        switch await feedUseCase.fetchComments(offset: nil) {
        case .success(let comments):
            self.comments = comments
            commentUIState = .success
        case .failure:
            commentUIState = .failure
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
    func fetchFavoriteTopics(offset: Int?) async -> Result<[Topic], APIError> {
        .success([])
    }
    
    func fetchComments(offset: Int?) async -> Result<[Comment], APIError> {
        .success([])
    }
}

enum UIState {
    case loading
    case success
    case failure
}

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
        switch await feedUseCase.fetchFavoriteTopics(offset: nil) {
        case .success(let topics):
            self.topics = topics
            topicUIState = .success
        case .failure(let error):
            switch error {
            case .decodingError, .networkError, .invalidStatus, .otherError:
                topicUIState = .failure
            case .errorResponse(let errorResponse, _):
                switch errorResponse.errorCode {
                case .USED_EMAIL, .CODE_INCORRECT_OR_EXPIRED, .NOT_CONFIRMED_EMAIL, .EMAIL_OR_PASSWORD_INCORRECT, .RESOURCE_NOT_FOUND, .INTERNAL_SERVER_ERROR:
                    topicUIState = .failure
                case .INVALID_ACCESS_TOKEN:
                    return
                }
            }
        }
    }
    
    func fetchComments() async {
        if commentUIState != .success {
            commentUIState = .loading
        }
        isCommentOnAppearFinished = true
        switch await feedUseCase.fetchComments(offset: nil) {
        case .success(let comments):
            self.comments = comments
            commentUIState = .success
        case .failure(let error):
            switch error {
            case .decodingError, .networkError, .invalidStatus, .otherError:
                commentUIState = .failure
            case .errorResponse(let errorResponse, _):
                switch errorResponse.errorCode {
                case .USED_EMAIL, .CODE_INCORRECT_OR_EXPIRED, .NOT_CONFIRMED_EMAIL, .EMAIL_OR_PASSWORD_INCORRECT, .RESOURCE_NOT_FOUND, .INTERNAL_SERVER_ERROR:
                    commentUIState = .failure
                case .INVALID_ACCESS_TOKEN:
                    return
                }
            }
        }
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

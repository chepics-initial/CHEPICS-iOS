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
    @Published private(set) var topicFooterStatus: FooterStatus = .loadingStopped
    @Published private(set) var commentFooterStatus: FooterStatus = .loadingStopped
    @Published var showLikeCommentFailureAlert = false
    @Published var showLikeReplyFailureAlert = false
    private var isTopicFetchStarted = false
    private var isCommentFetchStarted = false
    
    private let feedUseCase: any FeedUseCase
    
    init(feedUseCase: some FeedUseCase) {
        self.feedUseCase = feedUseCase
    }
    
    func selectTab(type: FeedTabType) {
        selectedTab = type
    }
    
    func onAppear() async {
        switch selectedTab {
        case .topics:
            if !isTopicFetchStarted {
                await fetchTopics()
            }
        case .comments:
            if !isCommentFetchStarted {
                await fetchComments()
            }
        }
    }
    
    func fetchTopics() async {
        if topicUIState != .success {
            topicUIState = .loading
        }
        isTopicFetchStarted = true
        switch await feedUseCase.fetchFavoriteTopics(offset: nil) {
        case .success(let topics):
            self.topics = topics
            topicFooterStatus = topics.count < Constants.arrayLimit ? .allFetched : .loadingStopped
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
            commentFooterStatus = comments.count < Constants.arrayLimit ? .allFetched : .loadingStopped
            commentUIState = .success
        case .failure:
            commentUIState = .failure
        }
    }
    
    func onTapLikeButton(comment: Comment) async {
        switch await feedUseCase.like(setId: comment.setId, commentId: comment.id) {
        case .success(let response):
            if let index = comments?.firstIndex(where: { $0.id == response.commentId }) {
                comments?[index].votes = response.count
                comments?[index].isLiked = response.isLiked
            }
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error {
                if errorResponse.errorCode == .ERROR_SET_NOT_PICKED {
                    showLikeCommentFailureAlert = true
                    return
                }
                
                if errorResponse.errorCode == .ERROR_TOPIC_NOT_PICKED {
                    showLikeReplyFailureAlert = true
                    return
                }
            }
        }
    }
    
    func onAppearTopicFooterView() async {
        guard topicFooterStatus == .loadingStopped || topicFooterStatus == .failure else { return }
        topicFooterStatus = .loadingStarted
        switch await feedUseCase.fetchFavoriteTopics(offset: topics?.count) {
        case .success(let additionalTopics):
            for additionalTopic in additionalTopics {
                if let index = topics?.firstIndex(where: { $0.id == additionalTopic.id }) {
                    topics?[index] = additionalTopic
                } else {
                    topics?.append(additionalTopic)
                }
            }
            topicFooterStatus = additionalTopics.count < Constants.arrayLimit ? .allFetched : .loadingStopped
        case .failure:
            topicFooterStatus = .failure
        }
    }
    
    func onAppearCommentFooterView() async {
        guard commentFooterStatus == .loadingStopped || commentFooterStatus == .failure else { return }
        commentFooterStatus = .loadingStarted
        switch await feedUseCase.fetchComments(offset: comments?.count) {
        case .success(let additionalComments):
            for additionalComment in additionalComments {
                if let index = comments?.firstIndex(where: { $0.id == additionalComment.id }) {
                    comments?[index] = additionalComment
                } else {
                    comments?.append(additionalComment)
                }
            }
            commentFooterStatus = additionalComments.count < Constants.arrayLimit ? .allFetched : .loadingStopped
        case .failure:
            commentFooterStatus = .failure
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
    
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError> {
        .success(mockLikeResponse)
    }
}

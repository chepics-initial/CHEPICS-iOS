//
//  ProfileViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/22.
//

import Foundation

@MainActor final class ProfileViewModel: ObservableObject {
    @Published var selectedTab: ProfileTabType = .topics {
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
    @Published private(set) var isCurrentUser: Bool = false
    @Published private(set) var user: User
    @Published private(set) var topics: [Topic]?
    @Published private(set) var comments: [Comment]?
    @Published private(set) var topicUIState: UIState = .loading
    @Published private(set) var commentUIState: UIState = .loading
    @Published private(set) var isFollowing: Bool?
    @Published private(set) var isEnabled: Bool = true
    @Published var showLikeCommentFailureAlert = false
    @Published var showLikeReplyFailureAlert = false
    @Published private(set) var topicFooterStatus: FooterStatus = .loadingStopped
    @Published private(set) var commentFooterStatus: FooterStatus = .loadingStopped
    private var isTopicFetchStarted = false
    private var isCommentFetchStarted = false
    private var isInitialAppear: Bool = true
    private var topicOffset = 0
    private var commentOffset = 0
    private let profileUseCase: any ProfileUseCase
    
    init(user: User, profileUseCase: some ProfileUseCase) {
        self.profileUseCase = profileUseCase
        self.user = user
        isFollowing = user.isFollowing
    }
    
    func selectTab(type: ProfileTabType) {
        selectedTab = type
    }
    
    func onAppear() async {
        if isInitialAppear {
            isInitialAppear = false
            isCurrentUser = user.id == profileUseCase.getCurrentUserId()
            switch await profileUseCase.fetchUserInformation(userId: user.id) {
            case .success(let user):
                self.user = user
                isFollowing = user.isFollowing
                switch selectedTab {
                case .topics:
                    await fetchTopics()
                case .comments:
                    await fetchComments()
                }
            case .failure:
                return
            }
        }
    }
    
    func fetchUser() async {
        switch await profileUseCase.fetchUserInformation(userId: user.id) {
        case .success(let user):
            self.user = user
            isFollowing = user.isFollowing
        case .failure:
            return
        }
    }
    
    func fetchTopics() async {
        if topicUIState != .success {
            topicUIState = .loading
        }
        isTopicFetchStarted = true
        switch await profileUseCase.fetchUserTopics(userId: user.id, offset: nil) {
        case .success(let topics):
            self.topics = topics
            topicFooterStatus = topics.count < Constants.arrayLimit ? .allFetched : .loadingStopped
            topicUIState = .success
            topicOffset = Constants.arrayLimit
        case .failure:
            topicUIState = .failure
        }
    }
    
    func fetchComments() async {
        if commentUIState != .success {
            commentUIState = .loading
        }
        isCommentFetchStarted = true
        switch await profileUseCase.fetchUserComments(userId: user.id, offset: nil) {
        case .success(let comments):
            self.comments = comments
            commentFooterStatus = comments.count < Constants.arrayLimit ? .allFetched : .loadingStopped
            commentUIState = .success
            commentOffset = Constants.arrayLimit
        case .failure:
            commentUIState = .failure
        }
    }
    
    func onTapFollowButton() async {
        isEnabled = false
        let result = await profileUseCase.follow(userId: user.id)
        isEnabled = true
        switch result {
        case .success(let isFollow):
            isFollowing = isFollow
            await fetchUser()
        case .failure:
            return
        }
    }
    
    func onTapLikeButton(comment: Comment) async {
        switch await profileUseCase.like(setId: comment.setId, commentId: comment.id) {
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
        switch await profileUseCase.fetchUserTopics(userId: user.id, offset: topicOffset) {
        case .success(let additionalTopics):
            for additionalTopic in additionalTopics {
                if let index = topics?.firstIndex(where: { $0.id == additionalTopic.id }) {
                    topics?[index] = additionalTopic
                } else {
                    topics?.append(additionalTopic)
                }
            }
            if additionalTopics.count < Constants.arrayLimit {
                topicFooterStatus = .allFetched
                topicOffset = 0
                return
            }
            topicFooterStatus = .loadingStopped
            topicOffset += Constants.arrayLimit
        case .failure:
            topicFooterStatus = .failure
        }
    }
    
    func onAppearCommentFooterView() async {
        guard commentFooterStatus == .loadingStopped || commentFooterStatus == .failure else { return }
        commentFooterStatus = .loadingStarted
        switch await profileUseCase.fetchUserComments(userId: user.id, offset: commentOffset) {
        case .success(let additionalComments):
            for additionalComment in additionalComments {
                if let index = comments?.firstIndex(where: { $0.id == additionalComment.id }) {
                    comments?[index] = additionalComment
                } else {
                    comments?.append(additionalComment)
                }
            }
            if additionalComments.count < Constants.arrayLimit {
                commentFooterStatus = .allFetched
                commentOffset = 0
                return
            }
            commentFooterStatus = .loadingStopped
            commentOffset += Constants.arrayLimit
        case .failure:
            commentFooterStatus = .failure
        }
    }
}

enum ProfileTabType: CaseIterable {
    case topics
    case comments
    
    var title: String {
        switch self {
        case .topics:
            "トピック"
        case .comments:
            "コメント"
        }
    }
}

final class ProfileUseCase_Previews: ProfileUseCase {
    func getCurrentUserId() -> String {
        ""
    }
    
    func fetchUserInformation(userId: String) async -> Result<User, APIError> {
        .success(mockUser1)
    }
    
    func fetchUserTopics(userId: String, offset: Int?) async -> Result<[Topic], APIError> {
        .success([])
    }
    
    func fetchUserComments(userId: String, offset: Int?) async -> Result<[Comment], APIError> {
        .success([])
    }
    
    func follow(userId: String) async -> Result<Bool, APIError> {
        .success(true)
    }
    
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError> {
        .success(mockLikeResponse)
    }
}

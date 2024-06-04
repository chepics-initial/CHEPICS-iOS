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
    @Published private(set) var showError = false
    @Published private(set) var isFollowing: Bool?
    @Published private(set) var isEnabled: Bool = true
    private var isTopicFetchStarted = false
    private var isCommentFetchStarted = false
    private var isInitialAppear: Bool = true
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
                switch selectedTab {
                case .topics:
                    await fetchTopics()
                case .comments:
                    await fetchComments()
                }
            case .failure(let error):
                if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_REFRESH_TOKEN {
                    return
                }
                showError = true
            }
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
        switch await profileUseCase.fetchUserComments(userId: user.id, offset: nil) {
        case .success(let comments):
            self.comments = comments
            commentUIState = .success
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
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_REFRESH_TOKEN {
                return
            }
            showError = true
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
}

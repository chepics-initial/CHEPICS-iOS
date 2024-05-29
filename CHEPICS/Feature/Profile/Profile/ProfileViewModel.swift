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
    @Published private(set) var isCurrentUser: Bool = false
    @Published private(set) var user: User
    @Published private(set) var topics: [Topic]?
    @Published private(set) var comments: [Comment]?
    @Published private(set) var topicUIState: UIState = .loading
    @Published private(set) var commentUIState: UIState = .loading
    @Published private(set) var showError = false
    private var isTopicOnAppearFinished = false
    private var isCommentOnAppearFinished = false
    private var isInitialAppear: Bool = true
    private let profileUseCase: any ProfileUseCase
    
    init(user: User, profileUseCase: some ProfileUseCase) {
        self.profileUseCase = profileUseCase
        self.user = user
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
        isTopicOnAppearFinished = true
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
        isCommentOnAppearFinished = true
        switch await profileUseCase.fetchUserComments(userId: user.id, offset: nil) {
        case .success(let comments):
            self.comments = comments
            commentUIState = .success
        case .failure:
            commentUIState = .failure
        }
    }
    
    func onDisappear() {
        isTopicOnAppearFinished = false
        isCommentOnAppearFinished = false
    }
    
    func onTapFollowButton() async {
        
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
}

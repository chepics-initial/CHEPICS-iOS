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
    @Published private(set) var user: User?
    @Published private(set) var topics: [Topic]?
    @Published private(set) var comments: [Comment]?
    @Published private(set) var topicUIState: UIState = .loading
    @Published private(set) var commentUIState: UIState = .loading
    @Published private(set) var showError = false
    private var isTopicOnAppearFinished = false
    private var isCommentOnAppearFinished = false
    private let userId: String
    private var isInitialAppear: Bool = true
    private let profileUseCase: any ProfileUseCase
    
    init(userId: String, profileUseCase: some ProfileUseCase) {
        self.profileUseCase = profileUseCase
        self.userId = userId
    }
    
    func selectTab(type: ProfileTabType) {
        selectedTab = type
    }
    
    func onAppear() async {
        if isInitialAppear {
            isInitialAppear = false
            switch await profileUseCase.fetchUserInformation(userId: userId) {
            case .success(let user):
                self.user = user
                switch selectedTab {
                case .topics:
                    await fetchTopics()
                case .comments:
                    await fetchComments()
                }
            case .failure(let error):
                switch error {
                case .decodingError, .networkError, .invalidStatus, .otherError:
                    showError = true
                case .errorResponse(let errorResponse, _):
                    switch errorResponse.errorCode {
                    case .USED_EMAIL, .CODE_INCORRECT_OR_EXPIRED, .NOT_CONFIRMED_EMAIL, .EMAIL_OR_PASSWORD_INCORRECT, .RESOURCE_NOT_FOUND, .INTERNAL_SERVER_ERROR:
                        showError = true
                    case .INVALID_ACCESS_TOKEN:
                        return
                    }
                }
            }
        }
    }
    
    func fetchTopics() async {
        if topicUIState != .success {
            topicUIState = .loading
        }
        isTopicOnAppearFinished = true
        switch await profileUseCase.fetchUserTopics(userId: userId, offset: nil) {
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
        switch await profileUseCase.fetchUserComments(userId: userId, offset: nil) {
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

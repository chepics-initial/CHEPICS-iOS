//
//  ExploreResultViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/18.
//

import Foundation

@MainActor
final class ExploreResultViewModel: ObservableObject {
    @Published var searchText: String
    @Published var selectedTab: SearchTabType = .topics {
        didSet {
            switch selectedTab {
            case .topics:
                if topicUIState != .success {
                    Task { await fetchTopics() }
                }
            case .comments:
                if commentUIState != .success {
                    Task { await fetchComments() }
                }
            case .users:
                if userUIState != .success {
                    Task { await fetchUsers() }
                }
            }
        }
    }
    @Published private(set) var topics: [Topic]?
    @Published private(set) var comments: [Comment]?
    @Published private(set) var users: [User]?
    @Published private(set) var topicUIState: UIState = .loading
    @Published private(set) var commentUIState: UIState = .loading
    @Published private(set) var userUIState: UIState = .loading
    @Published var showLikeCommentFailureAlert = false
    @Published var showLikeReplyFailureAlert = false
    @Published private(set) var topicFooterStatus: FooterStatus = .loadingStopped
    @Published private(set) var commentFooterStatus: FooterStatus = .loadingStopped
    @Published private(set) var userFooterStatus: FooterStatus = .loadingStopped
    let initialSearchText: String
    
    private var isInitialAppear = true
    
    private let exploreResultUseCase: any ExploreResultUseCase
        
    init(searchText: String, exploreResultUseCase: some ExploreResultUseCase) {
        self.searchText = searchText
        self.initialSearchText = searchText
        self.exploreResultUseCase = exploreResultUseCase
    }
    
    func selectTab(type: SearchTabType) {
        selectedTab = type
    }
    
    func onAppear() async {
        if isInitialAppear {
            isInitialAppear = false
            switch selectedTab {
            case .topics:
                await fetchTopics()
            case .comments:
                await fetchComments()
            case .users:
                await fetchUsers()
            }
        }
    }
    
    func fetchTopics() async {
        if topicUIState == .failure {
            topicUIState = .loading
        }
        
        switch await exploreResultUseCase.fetchSearchedTopics(word: searchText, offset: nil) {
        case .success(let topics):
            self.topics = topics
            if topics.count < Constants.arrayLimit {
                topicFooterStatus = .allFetched
            } else {
                topicFooterStatus = .loadingStopped
            }
            topicUIState = .success
        case .failure:
            topicUIState = .failure
        }
    }
    
    func fetchComments() async {
        if commentUIState == .failure {
            commentUIState = .loading
        }
        
        switch await exploreResultUseCase.fetchSearchedComments(word: searchText, offset: nil) {
        case .success(let comments):
            self.comments = comments
            if comments.count < Constants.arrayLimit {
                commentFooterStatus = .allFetched
            } else {
                commentFooterStatus = .loadingStopped
            }
            commentUIState = .success
        case .failure:
            commentUIState = .failure
        }
    }
    
    func fetchUsers() async {
        if userUIState == .failure {
            userUIState = .loading
        }
        
        switch await exploreResultUseCase.fetchSearchedUsers(word: searchText, offset: nil) {
        case .success(let users):
            self.users = users
            if users.count < Constants.arrayLimit {
                userFooterStatus = .allFetched
            } else {
                userFooterStatus = .loadingStopped
            }
            userUIState = .success
        case .failure:
            userUIState = .failure
        }
    }
    
    func onTapDeleteButton() {
        searchText = ""
    }
    
    func onTapLikeButton(comment: Comment) async {
        switch await exploreResultUseCase.like(setId: comment.setId, commentId: comment.id) {
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
                
                if errorResponse.errorCode == .ERROR_SET_NOT_PICKED {
                    showLikeReplyFailureAlert = true
                    return
                }
            }
        }
    }
    
    func onAppearTopicFooterView() async {
        guard topicFooterStatus == .loadingStopped || topicFooterStatus == .failure else { return }
        topicFooterStatus = .loadingStarted
        switch await exploreResultUseCase.fetchSearchedTopics(word: searchText, offset: topics?.count) {
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
            } else {
                topicFooterStatus = .loadingStopped
            }
        case .failure:
            topicFooterStatus = .failure
        }
    }
    
    func onAppearCommentFooterView() async {
        guard commentFooterStatus == .loadingStopped || commentFooterStatus == .failure else { return }
        commentFooterStatus = .loadingStarted
        switch await exploreResultUseCase.fetchSearchedComments(word: searchText, offset: comments?.count) {
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
            } else {
                commentFooterStatus = .loadingStopped
            }
        case .failure:
            commentFooterStatus = .failure
        }
    }
    
    func onAppearUserFooterView() async {
        guard userFooterStatus == .loadingStopped || userFooterStatus == .failure else { return }
        userFooterStatus = .loadingStarted
        switch await exploreResultUseCase.fetchSearchedUsers(word: searchText, offset: users?.count) {
        case .success(let additionalUsers):
            for additionalUser in additionalUsers {
                if let index = users?.firstIndex(where: { $0.id == additionalUser.id }) {
                    users?[index] = additionalUser
                } else {
                    users?.append(additionalUser)
                }
            }
            if additionalUsers.count < Constants.arrayLimit {
                userFooterStatus = .allFetched
            } else {
                userFooterStatus = .loadingStopped
            }
        case .failure:
            userFooterStatus = .failure
        }
    }
}

enum SearchTabType: CaseIterable {
    case topics
    case comments
    case users
    
    var title: String {
        switch self {
        case .topics:
            "トピック"
        case .comments:
            "コメント"
        case .users:
            "ユーザー"
        }
    }
}

final class ExploreResultUseCase_Previews: ExploreResultUseCase {
    func fetchSearchedTopics(word: String, offset: Int?) async -> Result<[Topic], APIError> {
        .success([])
    }
    
    func fetchSearchedComments(word: String, offset: Int?) async -> Result<[Comment], APIError> {
        .success([])
    }
    
    func fetchSearchedUsers(word: String, offset: Int?) async -> Result<[User], APIError> {
        .success([])
    }
    
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError> {
        .success(mockLikeResponse)
    }
}

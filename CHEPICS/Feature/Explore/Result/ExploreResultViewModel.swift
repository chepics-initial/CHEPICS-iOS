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
    let initialSearchText: String
    
    private var isFirstAppear = true
    
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
        if isFirstAppear {
            isFirstAppear = false
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
        if topicUIState != .success {
            topicUIState = .loading
        }
        
        switch await exploreResultUseCase.fetchSearchedTopics(word: searchText) {
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
        
        switch await exploreResultUseCase.fetchSearchedComments(word: searchText) {
        case .success(let comments):
            self.comments = comments
            commentUIState = .success
        case .failure:
            commentUIState = .failure
        }
    }
    
    func fetchUsers() async {
        if userUIState != .success {
            userUIState = .loading
        }
        
        switch await exploreResultUseCase.fetchSearchedUsers(word: searchText) {
        case .success(let users):
            self.users = users
            userUIState = .success
        case .failure:
            userUIState = .failure
        }
    }
    
    func onTapDeleteButton() {
        searchText = ""
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
    func fetchSearchedTopics(word: String) async -> Result<[Topic], APIError> {
        .success([])
    }
    
    func fetchSearchedComments(word: String) async -> Result<[Comment], APIError> {
        .success([])
    }
    
    func fetchSearchedUsers(word: String) async -> Result<[User], APIError> {
        .success([])
    }
}

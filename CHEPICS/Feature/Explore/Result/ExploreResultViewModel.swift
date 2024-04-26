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
    
    private var isFirstAppear = true
        
    init(searchText: String) {
        self.searchText = searchText
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
        
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        topics = [mockTopic1, mockTopic2, mockTopic3, mockTopic4]
        topicUIState = .success
    }
    
    func fetchComments() async {
        if commentUIState != .success {
            commentUIState = .loading
        }
        
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        comments = [mockComment1, mockComment2, mockComment3, mockComment4]
        commentUIState = .success
    }
    
    func fetchUsers() async {
        if userUIState != .success {
            userUIState = .loading
        }
        
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        users = [mockUser1, mockUser2, mockUser3, mockUser4]
        userUIState = .success
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

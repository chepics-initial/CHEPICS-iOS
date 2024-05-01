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
    @Published private(set) var topics: [Topic]?
    @Published private(set) var comments: [Comment]?
    @Published private(set) var topicUIState: UIState = .loading
    @Published private(set) var commentUIState: UIState = .loading
    private var isTopicOnAppearFinished = false
    private var isCommentOnAppearFinished = false
    
    private let profileUseCase: any ProfileUseCase
    
    init(profileUseCase: some ProfileUseCase) {
        self.profileUseCase = profileUseCase
    }
    
    func selectTab(type: ProfileTabType) {
        selectedTab = type
    }
    
    func fetchTopics() async {
        if topicUIState != .success {
            topicUIState = .loading
        }
        isTopicOnAppearFinished = true
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        topics = [mockTopic1, mockTopic2, mockTopic3, mockTopic4, mockTopic5, mockTopic6, mockTopic7, mockTopic8, mockTopic9, mockTopic10, mockTopic11, mockTopic12, mockTopic13, mockTopic14, mockTopic15]
        topicUIState = .success
    }
    
    func fetchComments() async {
        if commentUIState != .success {
            commentUIState = .loading
        }
        isCommentOnAppearFinished = true
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        comments = [mockComment1, mockComment2, mockComment3, mockComment4]
        commentUIState = .success
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
    
}

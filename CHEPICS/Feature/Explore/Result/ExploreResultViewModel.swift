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
                <#code#>
            case .comments:
                <#code#>
            case .users:
                <#code#>
            }
        }
    }
    @Published private(set) var topicUIState: UIState = .loading
    @Published private(set) var commentUIState: UIState = .loading
    @Published private(set) var userUIState: UIState = .loading
    
    private var isFirstAppear = true
        
    init(searchText: String) {
        self.searchText = searchText
    }
    
    func onAppear() async {
        if isFirstAppear {
            isFirstAppear = false
            switch selectedTab {
            case .topics:
                <#code#>
            case .comments:
                <#code#>
            case .users:
                <#code#>
            }
        }
    }
    
    func fetchTopics() async {
        
    }
    
    func fetchComments() async {
        
    }
    
    func fetchUsers() async {
        
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

//
//  FeedViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/19.
//

import Foundation

@MainActor final class FeedViewModel: ObservableObject {
    @Published private(set) var selectedTab: TabType = .topics
    
    init() {}
    
    func selectTab(type: TabType) {
        selectedTab = type
    }
}

enum TabType: CaseIterable {
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

//
//  ProfileViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/22.
//

import Foundation

@MainActor final class ProfileViewModel: ObservableObject {
    @Published private(set) var selectedTab: ProfileTabType = .topics
    
    private let profileUseCase: any ProfileUseCase
    
    init(profileUseCase: some ProfileUseCase) {
        self.profileUseCase = profileUseCase
    }
    
    func selectTab(type: ProfileTabType) {
        selectedTab = type
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

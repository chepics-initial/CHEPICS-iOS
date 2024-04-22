//
//  ExploreTopViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/16.
//

import Foundation

@MainActor
final class ExploreTopViewModel: ObservableObject {
    @Published var searchText = ""
    
    init() {}
    
    func onTapDeleteButton() {
        searchText = ""
    }
}

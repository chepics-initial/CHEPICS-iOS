//
//  MainTabViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/21.
//

import Foundation

final class MainTabViewModel: ObservableObject {
    @Published var images: [String] = []
    @Published var showImageViewer = false
    @Published var isTappedInFeed = false
    @Published private(set) var userId: String = ""
    @Published var pagerState: ImagePagerState = ImagePagerState(pageCount: 0, pageSize: .zero)
    
    private let mainTabUseCase: any MainTabUseCase
    
    init(mainTabUseCase: some MainTabUseCase) {
        self.mainTabUseCase = mainTabUseCase
        initialTask()
    }
    
    private func initialTask() {
        userId = mainTabUseCase.getUserId()
    }
}

final class MainTabUseCase_Previews: MainTabUseCase {
    func getUserId() -> String {
        ""
    }
}

//
//  MyPageTopViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/03.
//

import Foundation

@MainActor final class MyPageTopViewModel: ObservableObject {
    @Published private(set) var user:User?
    
    private let myPageTopUseCase: any MyPageTopUseCase
    
    init(myPageTopUseCase: some MyPageTopUseCase) {
        self.myPageTopUseCase = myPageTopUseCase
    }
    
    func onAppear() async {
        switch await myPageTopUseCase.fetchUser() {
        case .success(let user):
            self.user = user
        case .failure:
            return
        }
    }
}

final class MyPageTopUseCase_Previews: MyPageTopUseCase {
    func fetchUser() async -> Result<User, APIError> {
        .success(mockUser1)
    }
}

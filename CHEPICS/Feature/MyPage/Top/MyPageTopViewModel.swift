//
//  MyPageTopViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/03.
//

import Foundation

@MainActor final class MyPageTopViewModel: ObservableObject {
    @Published private(set) var user:User?
    @Published private(set) var uiModel: MyPageTopUIModel?
    
    private let myPageTopUseCase: any MyPageTopUseCase
    
    init(myPageTopUseCase: some MyPageTopUseCase) {
        self.myPageTopUseCase = myPageTopUseCase
    }
    
    func onAppear() async {
        if let storedUser = myPageTopUseCase.getUserData() {
            uiModel = MyPageTopUIModel(username: storedUser.username, fullname: storedUser.fullname, profileImageUrl: storedUser.profileImageUrl)
        }
        switch await myPageTopUseCase.fetchUser() {
        case .success(let user):
            self.user = user
            uiModel = MyPageTopUIModel(username: user.username, fullname: user.fullname, profileImageUrl: user.profileImageUrl)
        case .failure:
            return
        }
    }
    
    func logout() {
        myPageTopUseCase.logout()
    }
    
    // MARK: - 仮のユーザー削除処理
    func onTapDeleteButton() async {
        guard let user else { return }
        switch await myPageTopUseCase.deleteUser(userId: user.id) {
        case .success:
            return
        case .failure:
            return
        }
    }
}

struct MyPageTopUIModel {
    let username: String
    let fullname: String
    let profileImageUrl: String?
    
    init(username: String, fullname: String, profileImageUrl: String?) {
        self.username = username
        self.fullname = fullname
        self.profileImageUrl = profileImageUrl
    }
}

final class MyPageTopUseCase_Previews: MyPageTopUseCase {
    func fetchUser() async -> Result<User, APIError> {
        .success(mockUser1)
    }
    
    func logout() {
        
    }
    
    func getUserData() -> UserData? {
        nil
    }
    
    // MARK: - 仮のユーザー削除
    func deleteUser(userId: String) async -> Result<Void, APIError> {
        .success(())
    }
}

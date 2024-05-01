//
//  EditProfileViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/01.
//

import Foundation

@MainActor final class EditProfileViewModel: ObservableObject {
    @Published private(set) var isActive: Bool = true
    @Published private(set) var profileImageUrl: String?
    @Published var username: String
    @Published private(set) var fullname: String
    @Published private(set) var bio: String?
    
    init(user: User) {
        profileImageUrl = user.profileImageUrl
        username = user.username
        fullname = user.fullname
        bio = user.bio
    }
    
    func onTapSaveButton() async {
        
    }
}
